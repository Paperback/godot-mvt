extends Spatial
export var x: int = 0
export var y: int = 0
export var z: int = 1

var mat: Material

func _ready():
	mat = preload("res://scenes/main/material2.material")
	#material_override = mat
	var _z = 4
	for _x in range(0,32):
		for _y in range(0,32):
			_import('data', _z, _x, _y)
	#translate(Vector3(x * 4096, y * 4096, 0))

# warning-ignore:unused_argument
# warning-ignore:unused_argument
# warning-ignore:unused_argument
# warning-ignore:unused_argument
func _import(name, z, x, y):
	Log.verbose('Tile: importing %s: %s/%s-%s' % [name, z, x, y])
#	var request = $http.request('localhost:3000/public.points/%s-%s-%s' % [x, y, z]);
	var filename = "res://data/%s/%s-%s.pbf" % [z, x, y];
	print(filename)
	var file = File.new();
	var mvt = load('res://source/map/mvt/mvt3.gd')
	file.open(filename, File.READ);

	var length = file.get_len();
	Log.verbose('Tile: length %s' % length)
	var buffer = file.get_buffer(length);
	var mvtTile = preload("res://addons/mvt/MvtTile.cs").new()
	var data = MapData.new()
	var tile = mvtTile.import(self, buffer)
	data.geometry = geometry
	ResourceSaver.save('res://data/tiles/data-%s-%s-%s.tres' % [x, y, z], data)

var geometry = []
func geometry_add(geom):
	geometry.push_back(geom)
	#var poly = CSGPolygon.new()
	#poly.set_polygon(geom)
	#poly.set_material(mat)
	#poly.set_smooth_faces(true)
	#poly.set_snap(0.1)
	#poly.set_depth(5)
	#add_child(poly)
	



#extends Area
#class_name TTile
#
#var _id: Vector3
#var _size: Vector3
#var outside: = MeshInstance.new()
#
#func get_id():
#	return _id
#
#func _init(id: Vector3, size: Vector3):
#	_id = id
#	_size = size
#	translate(position())
#
#func center():
#	return (_id * _size) - (_size / 2.0)
#
#func position():
#	return _id * _size
#
#func _ready():
#	outside.mesh = MeshHelper.square(_size)
#	add_child(outside)
#
#	var outside = PoolVector2Array()
#	outside.append(Vector2(0, 0))
#	outside.append(Vector2(_size.x, 0))
#	outside.append(Vector2(_size.x, _size.z))
#	outside.append(Vector2(0, _size.z))
#	var collision = CollisionPolygon.new()
#	collision.polygon = outside
#	collision.depth = _size.y
#	add_child(collision)
