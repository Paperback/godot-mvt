extends Object
class_name Map

var _name: String
var _cursor := Vector2(0, 0)
var _center := Vector2(0, 0)
var _zoom: int
var _srid: int
var _bounds: MapBounds

func _init(name: String, srid: int = MapCoordinates.System.LOCAL) -> void:
	_name = name
	_srid = srid
	_setup()
	
func _setup() -> void:
	_bounds = MapBounds.new(_srid, Vector2(1,1))
	_center = MapCoordinates.center(_srid)
	recenter()

func bounds() -> MapBounds:
	return _bounds

func reset() -> void:
	_cursor = Vector2(0, 0)
	_zoom = 0

func recenter():
	reset()
	move(_bounds.min_zoom(), _center)

func move(level: int, position: Vector2) -> Vector3:
	zoom(level)
	return seek(position)

func zoom(level: int) -> int:
	_zoom += level
	_zoom = int(min(_bounds.min_zoom(), _zoom))
	_zoom = int(max(_bounds.max_zoom(), _zoom))
	return _zoom

func seek(position: Vector2) -> Vector3:
	var r = MapCoordinates.resolution(_srid, _zoom)
	_cursor += position
	return Vector3(_cursor.x / r.x, _cursor.y / r.y, _zoom)

func tile(coordinate: Vector3) -> MapTile:
	return MapTile.new(coordinate, _srid)
#func load_tiles() -> void:
	
#func read():
#	var position = _cursor # - _preload_radius
#	var size = _cursor # + _preload_radius
#	var tile = MapBounds.tile(4)
	
#	for x in range(position.x, size.x):
#		for y in range(position.y, size.y):
#			print([x,y])
#	var _check_tiles = PoolVector2Array()
#	for x in range(position.x / _bounds.x, size.x):
#		for y in range(position.y, size.y):
#			if(_bounds.inside(xy)):
#			_check_tiles.append(xy)
	
#	print(_bounds.additive(_check_tiles))
#	for tile in _tiles:
		
#
#func create_tile():
#	for z in range(_extent.zoom_min(), _extent.zoom_max()):
#		_tiles[z] = {}
#		var res = _extent.resolution(z)
#		for x in range(0, 5):
#			_tiles[z][x] = {}
#			for y in range(0, 5):
#				_tiles[z][x][y] = MapTile.new(z, x, y, res)
##
#
