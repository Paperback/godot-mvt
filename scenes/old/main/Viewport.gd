extends Viewport
#
#func draw_circle_arc_poly(center, radius, angle_from, angle_to, color):
#	var nb_points = 32
#	var points_arc = PoolVector2Array()
#	points_arc.push_back(center)
#	var colors = PoolColorArray([color])
#	for i in range(nb_points + 1):
#		var angle_point = deg2rad(angle_from + i * (angle_to - angle_from) / nb_points - 90)
#		points_arc.push_back(center + Vector2(cos(angle_point), sin(angle_point)) * radius)
#	draw_polygon(points_arc, colors)
#
#func draw_wind_line(center, length, deg, color):
#	var v = Vector2(0,0)
#	v.x = v.x * cos(deg) + v.y * sin(deg);
#	v.y = v.y * cos(deg) - v.x * sin(deg);
#	v.x = v.x + length;
#	v.y = v.y + length;
#	draw_line(center, center + v, color);
var _features;
var _layers;
var _polygons;
var _wip_points;
var _cursor;
func _init():
	_features = Array();
	_layers = Array();
	_polygons = Array();
	_cursor = Vector2(0, 0);
	_wip_points = PoolVector2Array();

# Called when the node enters the scene tree for the first time.
func _ready():
	return
	#_import('test1', '2', '1', '1')
	#for child in get_children():
	#	remove_child(child)
		
	#var bg: = ColorRect.new()
	#bg.color =(Color(1.0, 0.0, 0.5))
	#add_child(bg)
	#return
	#_import('pbf/countries/2/1-0', '1', '1', '1')
	_import('data', '1', '1', '1')
	#_import('data', '1', '1', '1')
	#_import('data', '1', '1', '0')
#	for x in range(0, 4):
#		for y in range(0, 4):
#			_import('table_source', '2', x, y)

#	var bounds = Line2D.new()
#	bounds.add_point(Vector2(-180, -90))
#	bounds.add_point(Vector2(-180, 90))
#	bounds.add_point(Vector2(180, 90))
#	bounds.add_point(Vector2(180, -90))
#	bounds.add_point(Vector2(-180, -90))
#	bounds.set_width(2)
#	bounds.set_default_color(Color(0.0,0.0,0.0,0.12))
#	add_child(bounds)
	create_shapes()
	#var t: ViewportTexture = get_texture()
	#var scene = PackedScene.new()
	#var result = scene.pack(t)
	#if result == OK:
	#var error = ResourceSaver.save("res://data/texture.res", t)

func _translate(position):
	return Vector2(position.x, position.y)
#	var r = 10;
#	return Vector2(x+1 / (r/2), y+1 / (r)) - Vector2(1, 1);


# warning-ignore:unused_argument
# warning-ignore:unused_argument
# warning-ignore:unused_argument
# warning-ignore:unused_argument
func _import(name, z, x, y):
#	var request = $http.request('localhost:3000/public.points/%s-%s-%s' % [x, y, z]);
	var filename = "res://data/%s/%s-%s.pbf" % [z, x, y];
	#var filename = "res://data/1/1-1.pbf"
	print(filename)
	var file = File.new();
	var mvt = load('res://source/map/mvt/mvt.gd')
	file.open(filename, File.READ);

	var length = file.get_len();
	var buffer = file.get_buffer(length);
	var tile = mvt.Tile.new();
	tile.from_bytes(buffer);
	var layers = tile.get_layers();
	for layer in layers:
		_layers.push_back(layer);
		print('LAYER ADD: ' + layer.get_name());
		var features = layer.get_features();
		print(layer.get_extent())
		for feature in features:
			_features.push_back(feature);
#			print(feature.get_tags())
#			print(feature.get_id())
#			print(feature.get_type())
#			if(feature.get_id() != null):
#			print('FEATURE ADD: ' + feature.get_tags().size());

func close_path(cursor):
#	if(_wip_points.size() == 0): return;
#	print(['CLOSEPATH'])
	var p = Polygon2D.new();
#	move_to(position)
	_wip_points.push_back(cursor)
	p.set_polygon(_wip_points)
	p.set_color(Color(0.5+randf()*0.5, 0.5+randf() * 0.5, 0.5+randf() * 0.5, 1.0));
	_polygons.append(p)

	add_child(p)
#	p.owner = get_tree().get_edited_scene_root()
	#_cursor = _wip_points[0]
	_wip_points = PoolVector2Array()
#	for point in range(0, data.size(), 2):
#		print(point)

func line_to(points):
	_wip_points.push_back(_cursor)
	for position in points:
		_cursor = _cursor + position
		_wip_points.push_back(_cursor)

func move_to(points):
	for position in points:
#		print(['MOVETO: ', position, _cursor+position])
		_cursor = position

func pick_data(data, index, count):
	var points = PoolVector2Array();
	var end = index+(count*2)

	print('picking...' + str(index) + ' - ' + str(end))
	for n in range(index, end, 2):
		var value2 = ((data[n] >> 1) ^ (-(data[n] & 1)))
		var value1 = ((data[n+1] >> 1) ^ (-(data[n+1] & 1)))

		var v = Vector2(value1, value2)
#		/ 406.68
		points.append(v)
	return points;

func create_shapes():
	if(_features.empty()): return;
	for feature in _features:
		var geometry = feature.get_geometry();
		var _original_cursor = Vector2(0,0)
		var n = 0
		while(n < geometry.size()):
			var command = geometry[n]
			var id = command & 0x7
			var count = command >> 3
			n = n + 1

			if(id == 1):
				print(['MoveTo: ', count])
				var data = pick_data(geometry, n, count);
				print(['move:', data])
				move_to(data)
				_original_cursor = _cursor
				n = n + (count * 2)
			elif(id == 2):
				print(['LineTo: ', count])
				var data = pick_data(geometry, n, count);
				#print(['lines: ', data]);
				#original_cursor = _cursor
				line_to(data)
				n = n + (count * 2)
			elif(id == 7):
				print(['ClosePath: ', count])
				#var data = pick_data(geometry, n, count);
				#print(['closepath:', data])
				close_path(_original_cursor)
				#n = n + (count * 2)
			else:
				print(['Unknown', id, count]);

