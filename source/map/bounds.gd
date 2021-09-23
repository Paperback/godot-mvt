extends Object
class_name MapBounds

var _position: Vector2
var _size: Vector2
var _zoom: Vector2
var _srid: int

func _init(srid: int, zoom: Vector2):
	_setup(srid, zoom)

func _setup(srid: int, zoom: Vector2) -> void:
	var bounds := MapCoordinates.bounds(srid)
	_srid = srid
	_position = bounds[0]
	_size = bounds[1] - _position + Vector2(1, 1)
	_zoom = zoom # + Vector2(0, 1)

func z():
	return range(_zoom.x, _zoom.y)

func x():
	return range(_position.x, _size.x + 1 - _position.x)

func y():
	return range(_position.y, _size.y + 1 - _position.y)

func zoom():
	return _zoom

func min_zoom() -> int:
	return int(_zoom.x)

func max_zoom() -> int:
	return int(_zoom.y)

func size():
	return _size
	
func position():
	return _position
	
static func tile(zoom: int) -> int:
	var cmax := 4096
	var res := (2 * cmax) / pow(2, zoom)
	return int(res)

func inside(point: Vector2):
	if point.x > _size.x+_position.x: return false
	if point.x < _position.x: return false
	if point.y > _size.y+_position.y: return false
	if point.y < _position.y: return false
	return true
	

#func additive(points: PoolVector2Array):
#	var selected := PoolVector2Array()
#	for point in points:
#		if point.x > _size.x: continue
#		if point.x < _position.x: continue
#		if point.y > _size.y: continue
#		if point.y < _position.y: continue
#		selected.append(point)
#	return selected
		
#func tiles(z: int):
#	var resolution = resolution(z)
#	return [resolution[0] / _width, resolution[1] / _height]
#
#func resolution(z: int):
#	return MapCoordinates.resolution(z, _srid)

	
#func _translate(to: int):
#
#
#func custom(z: Array, x: Array, y: Array):
#	_z = z
#	_x = x
#	_y = y

#func _setup():
#	for z in range(_z[0], _z[1]):
#		_resolutions[z] = [_resolution(z), _resolution(z)]

#func _resolution(z: int):
#	var m := 20037508.34
#	var res := (_extent*2) / (pow(2, z))
#	return res


#func resolution(z: int):
#	return _resolutions[z]
#
#func z():
#	return _z
#
#func zoom():
#	return _z
#
#func zoom_min():
#	return _z[0]
#
#func zoom_max():
#	return _z[1]
#
#func lat():
#	return _x
#
#func lat_min():
#	return _x[0]
#
#func lat_max():
#	return _x[1]
#
#func lon():
#	return _y
#
#func lon_min():
#	return _y[0]
#
#func lon_max():
#	return _y[1]
