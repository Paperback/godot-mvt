extends Object
class_name MapCoordinates

enum Ratio {
	UNKNOWN = 1,
	LOCAL = 512,
	WORLD = 2048,
	MVT = 4096,
	PERCENT = 100,
	SRID_4326 = 180,
	SRID_3857 = 20037508
}

enum System {
	UNKNOWN = -1,
	LOCAL = 1,
	WORLD = 2,
	MVT = 3,
	PERCENT = 100,
	SRID_4326 = 4326,
	SRID_3857 = 3857
}

#enum Type {
#	UNKNOWN = -1,
#	LOCAL = 0,
#	SPATIAL = 1
#}

var _srid : int

func _init(srid := System.LOCAL):
	_srid = srid


	
#static func convert(zoom: int, srid: int, point Vector2):
#	match srid:
#		System.LOCAL:
#			return point / resolution(zoom, srid)
		
#func convert(points: PoolVector2Array, from: int, to: int):

static func center(srid: int) -> Vector2:
	match srid:
		System.LOCAL:
			return Vector2(Ratio.LOCAL * 2, Ratio.LOCAL)
		System.WORLD:
			return Vector2(Ratio.WORLD * 2, Ratio.WORLD)
		System.PERCENT:
			return Vector2(50, 50)
		System.MVT:
			return Vector2(Ratio.MVT, Ratio.MVT / 2)
		System.SRID_4326:
			return Vector2(0, 0)
		System.SRID_3857:
			return Vector2(0, 0)
	return Vector2(0, 0)

static func bounds(srid: int) -> PoolVector2Array:
	match srid:
		System.LOCAL:
			return PoolVector2Array([Vector2(1, 1), Vector2(Ratio.LOCAL * 2, Ratio.LOCAL)])
		System.WORLD:
			return PoolVector2Array([[1, 1], [Ratio.WORLD, Ratio.WORLD / 2]])
		System.PERCENT:
			return PoolVector2Array([[Ratio.PERCENT / 100, Ratio.PERCENT / 100], [Ratio.PERCENT, Ratio.PERCENT]])
		System.MVT:
			return PoolVector2Array([[1, 1], [Ratio.MVT, Ratio.MVT / 2]])
		System.SRID_4326:
			return PoolVector2Array([[Ratio.SRID_4326 * -1, Ratio.SRID_4326 * -1], [Ratio.SRID_4326, Ratio.SRID_4326]])
#			return PoolVector2Array([[Ratio.SRID_4326 * -1, Ratio.SRID_4326], [Ratio.SRID_4326 / 2 * -1, Ratio.SRID_4326 / 2]])
		System.SRID_3857:
			return PoolVector2Array([[Ratio.SRID_3857 * -1, Ratio.SRID_3857 * -1], [Ratio.SRID_3857, Ratio.SRID_3857]])
#			return PoolVector2Array([[Ratio.SRID_3857 * -1, Ratio.SRID_3857], [Ratio.SRID_3857 * -1, Ratio.SRID_3857]])
	return PoolVector2Array([[1, 1024], [1, 1024]])

#static func size(srid: int) -> int:
#	match srid:
#		System.GAME:
#			return Ratio.GAME

#static func size(srid: int):
#	match srid:
#		System.WORLD:
#			return PoolVector2Array([[], []])

static func resolution(z: int, srid: int) -> Vector2:
	var bounds := bounds(srid)
	var position := bounds[0]
	var size := bounds[1] - position + Vector2(1,1)
	var expo: float = pow(2, z)
	
	return Vector2(size.x * 2, size.y * 2) / Vector2(expo, expo)
#	var m := bounds[0][1]
#	var res := (m*2) / (pow(2, z))
#	return res
