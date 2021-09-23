extends Object
class_name TileBounds

var _position: Vector2
var _size: Vector2
var _zoom: int
var _srid: int

func _init(z: int, x: int, y: int, srid: int) -> void:
	_srid = srid
	_position = Vector2(x, y)
	_size = MapCoordinates.resolution(_zoom, _srid)
	_zoom = z
	print(['INIT TILE BOUNDS', _srid, _position, _size, _zoom])


#func resolution(z: int, srid: int) -> Vector2:
#	return MapCoordinates.resolution(_zoom, srid)
