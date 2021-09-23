extends Node2D

var _features;
var _layers;
var _polygons;
var _wip_points;
var _point
var _cursor;
var _p = Polygon2D.new()
export var x: int = 0
export var y: int = 0
export var z: int = 1

func _init():
	_features = Array()
	_layers = Array()
	_polygons = Array()
	_cursor = Vector2(0, 0)
	_wip_points = PoolVector2Array()
	_point = PoolVector2Array()
	Log.verbose('Tile: initialized')

func _ready():
	return
	_import('data', z, x, y)
	#position.x = (x + 1) * 4098.0
	#position.y = (y + 1) * 4098.0
	create_shapes()
	#_p.set_polygon(_point)
	#add_child(_p)

func _translate(position):
	return Vector2(position.x, position.y)

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
	var tile = mvt.Tile.new();
	tile.from_bytes(buffer);
	var layers = tile.get_layers();
	for layer in layers:
		_layers.push_back(layer);
		Log.verbose('Tile: layer %s' % layer.get_name())
		var features = layer.get_features();
		#Log.verbose('Tile: layer extent %s' % layer.get_extent())
		#Log.verbose('Tile: layer features %s' % features.size())
		for feature in features:
			_features.push_back(feature)
#			Log.verbose('Tile: layer feature tags: print(feature.get_tags())
#			print(feature.get_id())
			#Log.verbose('Tile: layer feature type %s' % feature.get_type())
#			if(feature.get_id() != null):
#			print('FEATURE ADD: ' + feature.get_tags().size());

func close_path(cursor):
#	if(_wip_points.size() == 0): return
	#if(cursor.y < 0)
#	print(['CLOSEPATH'])
	#move_to(position)
	
#	if !Geometry.is_polygon_clockwise(_wip_points):
#		_wip_points = PoolVector2Array()
#		return
	var p = Polygon2D.new()
	_wip_points.push_back(cursor)
	#_wip_points.push_back(_wip_points[0])
	#_point = Geometry.merge_polygons_2d(_point, _wip_points)
	p.set_polygon(_wip_points)
	p.set_color(Color(cursor.x / 4098.0, cursor.y / 4098.0, 0.5, 1.0));
	#_polygons.append(p)
	add_child(p)
#	else:
#		var p = Polygon2D.new();
#		_wip_points.push_back(cursor)
#		p.set_polygon(_wip_points)
#		p.set_color(Color(1.0, 0.0, 0.0, 1.0));
#		_polygons.append(p)
#		add_child(p)
#	p.owner = get_tree().get_edited_scene_root()
	#_cursor = _wip_points[0]
	_wip_points = PoolVector2Array()
#	for point in range(0, data.size(), 2):
#		print(point)

func line_to(points):
#	_wip_points.push_back(_cursor) This should be here?
	#Log.verbose('Tile LINE %s' % [points.size()])
	for position in points:
		_cursor = _cursor + position
		_wip_points.push_back(_cursor)

func move_to(points):
	for position in points:
		print(['MOVETO: ', position, _cursor+position])
		_cursor = position

func pick_data(data, index, count):
	var points = PoolVector2Array();
	var end = index+(count*2)

	#Log.verbose('Tile: picking %s in %s' % [index, end])
	#print('picking...' + str(index) + ' - ' + str(end))
	for n in range(index, end, 2):
		var value2 = ((data[n] >> 1) ^ (-(data[n] & 1)))
		var value1 = ((data[n+1] >> 1) ^ (-(data[n+1] & 1)))
		var v = Vector2(value1, value2)
#		if(v.length() > 0):
			#Log.verbose('Tile: %s got %s %s' % [n, v.x, v.y])
		points.append(v)
	return points;

enum commands {
	MOVE = 1,
	LINE = 2,
	END = 7
}

func create_shapes():
	if(_features.empty()): return
	var _original_cursor = Vector2(0,0)
	#var _line_cursor = Vector2(0,0)
	for feature in _features:
		var geometry = feature.get_geometry()
		var n = 0
		var depth = 0
		var mode = 0
		var buffer = PoolStringArray()
		while(n < geometry.size()):
			var command = geometry[n]
			var id = command & 0x7
			var count = command >> 3
			n = n + 1
			buffer.append('%s=%s:%s' % [command, id, count])
			if(id == commands.MOVE):
				#Log.verbose('Tile: MOVE %s %s' % [count, depth])
				#print(['MoveTo: ', count])
				var data = pick_data(geometry, n, count);
				#print(['move:', data])
				move_to(data)
				_original_cursor = _cursor
				n = n + (count * 2)
			elif(id == commands.LINE):
				#Log.verbose('Tile: LINE %s %s' % [count, depth])
				#if mode == 0:
				depth = depth + 1
				#if(depth >= 2): assert(true)
					#mode = 1
				
				#print(['LineTo: ', count])
				var data = pick_data(geometry, n, count);
				#print(['lines: ', data]);
				#original_cursor = _cursor
				line_to(data)
				n = n + (count * 2)
			elif(id == commands.END):
				#Log.verbose('Tile: END %s %s' % [count, depth])
				depth = depth - 1
				
				if(_cursor.x < 1.0 and _cursor.y < 1.0):
					print('HERE')
					print(buffer)
					print(depth)
					print(_cursor)
					print(_wip_points)
					print(n)
#					print(command)
					print('.....')
					buffer = PoolStringArray()
				#else:
					#_wip_points = PoolVector2Array()
				close_path(_original_cursor)
				#Log.verbose('Tile: feature command:%s id:%s count:%s' % [command, id, count])
				#Log.verbose('Tile: close %s:%s' % [_original_cursor.x, _original_cursor.y])
				#print(['ClosePath: ', count])
				#var data = pick_data(geometry, n, count);
				#print(['closepath:', data])
				
				
				#n = n + (count * 2)
			else:
				Log.warning('Tile: unknown command %s' % id)
				#print(['Unknown', id, count]);

