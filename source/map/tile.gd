extends Node2D
class_name MapTile

var _coordinate: Vector3
var _srid: int
var _resolution: int

func _init(coordinate: Vector3, srid: int) -> void:
	_coordinate = coordinate
	_srid = srid
	_resolution = resolution()

func resolution() -> int:
	var cmax := 4096
	var res := (2 * cmax) / pow(2, _coordinate.z)
	return int(res)

func coordinate() -> Vector3:
	return _coordinate

func bounds() -> PoolVector2Array:
	var r3 = Vector3(resolution(), resolution(), 0)
	var b = MapCoordinates.bounds(_srid)
	var bounds = b[1] - b[0]
	var size3 = Vector3(bounds.x, bounds.y, 0)
	var position = coordinate() * r3
	var size = position + size3
	print(size3)
	return PoolVector2Array([position, size])

func inside(point: Vector2) -> bool:
	var pos := Vector2(_coordinate.x, _coordinate.y) * Vector2(_resolution, _resolution)
	var size := pos + Vector2(_resolution, _resolution)
	if point.x > size.x: return false
	if point.x < pos.x: return false
	if point.y > size.y: return false
	if point.y < pos.y: return false
	return true
	
