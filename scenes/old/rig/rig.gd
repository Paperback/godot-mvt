tool
extends Spatial
class_name CameraRig

export(float, -500.0, 100.0, 0.1) var zoom := -50.0 setget set_zoom
#export(float, -200, 200.0, 0.1) var height := 100.0 setget set_height
export(float, 0.0, 360.0, 45.0) var direction := 0.0 setget set_direction

onready var camera: Camera = ($Camera as Camera) setget set_camera
onready var camera_original: Transform = (camera as Spatial).transform
onready var size: float = (camera as Camera).size setget set_size
onready var dirty: bool = true

func _ready():
	set_process(true)
	InputMap.load_from_globals()

func _find_camera() -> void:
	for child in get_children():
		if child is Camera:
			camera = child
			break

func visibility_changed():
	_sync_camera()

func _sync_camera() -> void:
	if(!camera): _find_camera()
	camera.transform = Transform()
	camera.set_rotation_degrees(Vector3(-45.0, -45.0, 0.0))
	#translate(Vector3(0.0, 0.0, 4.0))
	
func _process(delta) -> void:
	check_actions(delta * 100.0)
	if(dirty): _sync_camera()

func _input(event):
	if event is InputEventMouseButton:
		var s = 5.0
		if event.button_index == BUTTON_WHEEL_UP:
			set_size(size + 5 * s)
			translate(Vector3(0, 1 * s, 0))
		elif event.button_index == BUTTON_WHEEL_DOWN:
			set_size(size - 5 * s)
			translate(Vector3(0, -1 * s, 0))
func set_camera(value: Camera) -> void:
	camera = value
	size = camera.size
	
	#camera.global_translate(global_transform.origin)
	#camera.set_rotation_degrees(Vector3(-45.0, -45.0, 0.0))
	#camera.translate(camera.transform.basis.z * distance)
	#_sync_camera()

func set_zoom(value: float) -> void:
	#if(camera):
	#	camera.translate_object_local(camera.transform.basis.z * (distance - value))
	zoom = value
	dirty = true

func set_size(value: float) -> void:
	if camera: camera.set_size(size)
	size = value

func sync_direction():
	set_rotation_degrees(Vector3(0.0, 0.0, 0.0))
	set_direction(direction)

func set_direction(value: float) -> void:
	var rot := get_rotation_degrees()
	rot.y = value
	direction = value
	set_rotation_degrees(rot)

func get_direction() -> float:
	return direction

func reset_direction() -> void:
	set_direction(0.0)

func check_actions(delta):
	var s = 1 * delta
#	if(Input.is_action_pressed('move_in')):
		#set_size(size + 100.0 * s)
		#set_height(height + 1.0 * s)
#	elif(Input.is_action_pressed('move_out')):
		#set_size(size + -100.0 * s)
		#set_height(height + -1.0 * s)
	if(Input.is_key_pressed(KEY_SHIFT)):
		s *= 2
	if(Input.is_action_pressed('move_left')):
		translate_object_local(-camera.transform.basis.x * s * 2)
	elif(Input.is_action_pressed('move_right')):
		translate_object_local(camera.transform.basis.x * s * 2)
	if(Input.is_action_pressed('move_front')):
		translate_object_local(-camera.transform.basis.z * s * 2)
		translate_object_local(camera.transform.basis.y * s * 2)
	elif(Input.is_action_pressed('move_back')):
		translate_object_local(camera.transform.basis.z * s * 2)
		translate_object_local(-camera.transform.basis.y * s * 2)
	if(Input.is_action_pressed('rotate_left')):
		set_direction(direction + 1.0 * s)
	if(Input.is_action_pressed('rotate_right')):
		set_direction(direction + 1.0 * s * -1)


#func check_event(event):
#	var shift = 4
#	if(event is InputEventWithModifiers):
#		if(event.shift):
#			shift = 10
#
#	if(event.is_action('move_in')):
#		set_size(1.0)
#	if(event.is_action('move_out')):
#		set_size(-1.0)
#	if(event.is_action_pressed('rotate_left', true)):
#		set_direction(45.0 / 2)
#	if(event.is_action_pressed('rotate_right', true)):
#		set_direction(-45.0 / 2)
#
#	if(Input.action_press('move_left')):
#		translate_object_local(-camera.transform.basis.x * shift)
#		print('move_left')
#	if(event.is_action_pressed('move_right', true)):
#		translate_object_local(camera.transform.basis.x * shift)
#	if(Input.action_press('move_front')):
#		translate_object_local(camera.transform.basis.y * shift)
#		print('move_front')
#	if(event.is_action_pressed('move_back', true)):
#		translate_object_local(-camera.transform.basis.y * shift)
	
	
