extends RigidBody
class_name Agent

var code: = 0
var branch: = 0
var state: = {}
var size: Vector3
var tile

enum opcode {
	PREHOOK,
	POSTHOOK,
	WAIT,
	THINK,
	DO
}

enum command {
	CLEAR,
	MOVE
}

func _ready():
	set_use_custom_integrator(true)
	#custom_integrator(true)
	size = Vector3(1.0, 1.0, 1.5)
#	var mi = MeshHelper.build(MeshHelper.arrow(Vector3.FORWARD))
#	add_child(mi)
	
	var mi2 = MeshHelper.build(MeshHelper.box(size))
	add_child(mi2)
	
	var outside = PoolVector2Array()
	outside.append(Vector2(0.0, 0.0))
	outside.append(Vector2(size.x, 0.0))
	outside.append(Vector2(size.x, size.z))
	outside.append(Vector2(0.0, size.z))
	var collision = CollisionPolygon.new()
	collision.polygon = outside
	collision.depth = size.y
	add_child(collision)

func set_tile(value):
	#print(value.get_id())
	tile = value
	
func _posthook():
	pass

func _prehook():
	pass

func _process(delta):
	match code:
		opcode.POSTHOOK:
			pass
			#print('posthook')
		opcode.PREHOOK:
			#print('PREHOOK')
			_think(delta)
		opcode.WAIT:
			pass
		opcode.THINK:
			#print('THINK')
			_think(delta)
		opcode.DO:
			_do(delta)

func _think(delta):
	if branch == command.CLEAR:
		state = {}
	code = opcode.DO
	branch = command.MOVE

func _do(delta):
	pass

var direction: = Vector2(0,0)
onready var throttle: = randf() * 2.0
onready var stall: = 1.0
var stalling = false

func _integrate_forces(state):
	if state.linear_velocity.length_squared() < throttle:
		add_force(state.transform.basis.xform(Vector3(0,0,1)), Vector3(0,0,0))
	if state.linear_velocity.length_squared() <= stall:
		stalling = true
		add_force(state.transform.basis.xform(Vector3(0,-5,0)), Vector3(0,0,0))
	else:
		stalling = false


#
#func look_follow(state, current_transform, target_position):
#	var up_dir = Vector3(0, 1, 0)
#	var cur_dir = current_transform.basis.xform(Vector3(0, 0, 1))
#	var target_dir = (target_position - current_transform.origin).normalized()
#	var rotation_angle = acos(cur_dir.x) - acos(target_dir.x)
#
#	state.set_angular_velocity(up_dir * (rotation_angle / state.get_step()))
#
#func _integrate_forces(s):
#	if not state.keys().has('dir'): return
#	var dir = rotation.direction_to(state['dir'])
#	var forwards = rotation
#
#	s.set_angular_velocity(Vector3.AXIS_Z * forwards - dir)
##	var rotation_angle = acos(rotation.x) - acos(dir.x)
##	if(rotation_angle < 0.8):
##		#print(rotation_angle)
##		s.set_angular_velocity(Vector3.UP * (rotation_angle / 100 / s.get_step()))
#
#
#	s.set_linear_velocity(rotation * s.get_step())

#func _do(delta):
#	match branch:
#		command.MOVE:
#			if not state.keys().has('dir'): 
#				state['dir'] = Vector3(800.0, 100.0, 800.0)
#			var distance = translation.distance_to(state['dir'])
##			var distance_y = (translation * Vector3.UP).distance_to(state['dir'] * Vector3.UP) 
##			var dir = translation.direction_to(state['dir'])
##			var forwards = rotation
#			#print(distance_y)
#			#translate(Vector3.UP * distance_y * delta / 100.0)
#			#rotate(Vector3.LEFT, (forwards - dir).x * delta)
#			if distance < 10.0:
#				branch = command.CLEAR
#				code = opcode.THINK
##
#
#			#add_force(forwards * Vector3.UP * delta, dir - forwards * Vector3.AXIS_Y)
#			#add_central_force(Vector3(300.0, 300.0, 300.0) * delta * Vector3.UP)
#			#add_force(Vector3(10.0, 10.0, 10.0) * delta * forwards, dir)
#			#add_force()
#
#			#add_torque(dir * delta)
#			#add_central_force(Vector3(1.0, 1.0, 1.0) * delta)
#			#add_force(Vector3(1,1,1) * diff / 3600.0, dir)
#			#add_force(Vector3(1,1,1) * delta * 100.0, Vector3.ZERO)
#
#			#add_force(), dir * Vector3.UP)
#			#add_central_force(rotation * Vector3.FORWARD * delta * 500.0)
#
#
#func _do2(delta):
#	match branch:
#		command.MOVE:
#			if !state.keys().has('dir'):
#				state['dir'] = Vector3(randf() * 1800.0, randf() * 10.0, randf() * 800.0)
#			#add_central_force(Vector3(1000.0 * delta, 0.0, 0.0))
#			var dirto = translation.direction_to(state['dir'])
#			#if(dirto.length_squared() >= 2.0):
##			add_torque(rotation - translation.direction_to(state['dir']))
#
#			var f = rotation
#			#f.y = 0
##			add_force(f * delta * 500.0, Vector3(0,0, 500.0 * delta)
#			#add_central_force(translation.direction_to(state['dir']) * delta)
#			translate(Vector3(0, 1.0 * delta, 0))
#			#add_force(Vector3(0.0, delta * 1000.0, 0.0), Vector3(0.0, 0.0, 0.0))
#			if(randf() > 0.95):
#				state['dir'] = Vector3(randf() * 1800.0, randf() * 100.0, randf() * 800.0)
#	code = opcode.THINK
#	branch = command.CLEAR
