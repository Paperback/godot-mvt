extends Node2D
class_name MapNode

#signal tile_read
signal tile_load
signal tile_unload

var _map: Map
var _srid: int = MapCoordinates.System.LOCAL
var _preload_radius := Vector2(1,1)
var _name: String
var _tiles: PoolVector3Array

func _ready():
	_name = 'world1'
	_map = Map.new(_name, _srid)
	_debug_bounds(_map)
	seek(Vector2(1,1))

func zoom(level: int):
	_map.zoom(level)

func seek(position: Vector2):
	read(_map.seek(position))

func move(level: int, position: Vector2):
	zoom(level)
	seek(position)

func tile(position: Vector3) -> Object:
	return MapTile.new(position, _srid)

func read(cursor: Vector3):
	var position := Vector2(1,1) #Vector2(cursor.x, cursor.y) - _preload_radius
	var size := Vector2(12,12) #Vector2(cursor.x, cursor.y) + _preload_radius
	var level := cursor.z
	print('read')
	for t in range(0, _tiles.size()):
		var tile = tile(_tiles[t])
		if(!tile.inside(position, size)):
			_tiles.remove(t)
			emit_signal("tile_unload", tile)
	
	for x in range(position.x, size.x):
		for y in range(position.y, size.y):
			var t = Vector3(x, y, level)
			_tiles.append(t)
			emit_signal("tile_load", tile(t))

func _debug_bounds(map: Map):
	var position = map.bounds().position()
	var size = map.bounds().size() + position
	var line1 := Line2D.new()
	line1.set_width(2)
	line1.set_default_color(Color(1.0, 0.0, 0.0))
	line1.add_point(Vector2(position.x, position.y))
	line1.add_point(Vector2(size.x, position.y))
	line1.add_point(Vector2(size.x, size.y))
	line1.add_point(Vector2(position.x, size.y))
	line1.add_point(Vector2(position.x, position.y))
#	line1.add_point(Vector2(size.x, position.y))
	add_child(line1)

	var line2 := Line2D.new()
	line2.set_width(2)
	line2.set_default_color(Color(1.0, 0.0, 0.0, 0.5))
	line2.add_point(Vector2(position.x, position.y))
	line2.add_point(Vector2(size.x, size.y))
	add_child(line2)
	
	var label := RichTextLabel.new()
	label.set_bbcode('[color=blue][wave amp=50 freq=2]%s: %s,\n%s,%s:%s,%s[/wave][/color]' % [_name, _srid, position.x, position.y, size.x, size.y])
	add_child(label)
	label.rect_position = position
	label.rect_size = size

