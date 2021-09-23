extends Node2D
class_name Potato
export var x: int = 0
export var y: int = 0
export var z: int = 1

func _ready():
	_import('data', z, x, y)
	translate(Vector2(x * 4096, y * 4096))

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
	var tile = mvtTile.import(self, buffer)

func geometry_add(geom):
	var poly = Polygon2D.new()
	poly.set_polygon(geom)
	add_child(poly)
	

