tool
extends Node2D
class_name CameraRig2D

onready var camera: Camera2D = ($Camera2D as Camera2D) setget set_camera
onready var camera_original: Transform2D = (camera as Node2D).transform
onready var zoom: Vector2 = (camera as Camera2D).zoom setget set_zoom
onready var dirty: bool = true

func _ready():
	set_process(true)

func _find_camera() -> void:
	for child in get_children():
		if child is Camera2D:
			camera = child
			break

func visibility_changed():
	_sync_camera()

func _sync_camera() -> void:
	if(!camera): _find_camera()
	camera.transform = Transform()
#	camera.set_rotation_degrees(Vector3(-45.0, -45.0, 0.0))
	#translate(Vector3(0.0, 0.0, 4.0))

func _process(delta) -> void:
	check_actions(delta * 100.0)
	if(dirty): _sync_camera()

func _input(event):
	pass
#	if event is InputEventMouseButton:
#		var s = 5.0
#		if event.button_index == BUTTON_WHEEL_UP:
#			set_size(size + 5 * s)
##			translate(Vector2(0, 1 * s, 0))
#		elif event.button_index == BUTTON_WHEEL_DOWN:
#			set_size(size - 5 * s)
##			translate(Vector3(0, -1 * s, 0))

func set_camera(value: Camera2D) -> void:
	camera = value
	zoom = camera.zoom

func set_zoom(value: Vector2) -> void:
	if camera: camera.set_zoom(value)
	zoom = value

func check_actions(delta):
	var s = 10 * delta
	var ss = 0.1 * delta

	if(Input.is_action_pressed('rotate_left')):
		set_zoom(zoom + (zoom * ss))
	elif(Input.is_action_pressed('rotate_right')):
		set_zoom(zoom + (zoom * -ss))
	if(Input.is_key_pressed(KEY_SHIFT)):
		s *= s
	if(Input.is_action_pressed('move_left')):
		position.x += s
	elif(Input.is_action_pressed('move_right')):
		position.x -= s
	
	if(Input.is_action_pressed('move_front')):
		position.y += s
	elif(Input.is_action_pressed('move_back')):
		position.y -= s
	
