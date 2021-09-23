extends Spatial

#func draw_circle_arc_poly(center, radius, angle_from, angle_to, color):
#	var nb_points = 32
#	var points_arc = PoolVector2Array()
#	points_arc.push_back(center)
#	var colors = PoolColorArray([color])
#	for i in range(nb_points + 1):
#		var angle_point = deg2rad(angle_from + i * (angle_to - angle_from) / nb_points - 90)
#		points_arc.push_back(center + Vector2(cos(angle_point), sin(angle_point)) * radius)
#	draw_polygon(points_arc, colors)

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

func _ready():
	_import('table_source', Vector3(0, 0, 1))
#	_import('table_source', Vector3(0, 1, 1))
#	var z = 1
#	for x in range(0, 6):
#		for y in range(0, 4):
#			_import('table_source', Vector3(x, y, z))
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
	var scene = PackedScene.new()
	# Only `node` and `rigid` are now packed.
	var result = scene.pack(self)
	if result == OK:
		var error = ResourceSaver.save("res://data/tile.scn", scene)

func _translate(position):
	return position
	#return Vector2(position.x / 1000, position.y / 2000)

func _import(name, position):
	var filename = "res://data/%s/%s-%s.pbf" % [position.z, position.x, position.y];
	var file = File.new();
	var mvt = load('res://source/map/mvt/mvt.gd');
	file.open(filename, File.READ);
	var length = file.get_len();
	print(filename)
	print(length)
	var buffer = file.get_buffer(length);
	var tile = mvt.Tile.new(); 
	tile.from_bytes(buffer);
	var layers = tile.get_layers();
	for layer in layers:
		_layers.push_back(layer);
		print('LAYER ADD: ' + layer.get_name());
		var features = layer.get_features();
		for feature in features:
			_features.push_back(feature);
#			print(layer.get_extent())
#			print(feature.get_tags())
#			print(feature.get_id())
#			print(feature.get_type())
#			if(feature.get_id() != null):
#			print('FEATURE ADD: ' + feature.get_tags().size());

func close_path():
#	if(_wip_points.size() == 0): return;
#	print(['CLOSEPATH'])
	
	var p = Polygon2D.new()
	#p.depth = 0.5
#	move_to(position)
#	_wip_points.append(_wip_points[0])
	p.set_polygon(_wip_points)
	#p.set_color(Color(0.2+randf()*0.8, 0.4+randf() * 0.6, 0.3+randf() * 0.7, 0.9));
	_polygons.append(p)
	add_child(p)
	p.set_owner(self)
	_wip_points = PoolVector2Array()
	_cursor = Vector2(0,0)
#	for point in range(0, data.size(), 2):
#		print(point)

func line_to(points):
	for position in points:
		_cursor = _cursor + position
		_wip_points.append(_translate(_cursor))

func move_to(points):
	for position in points:
#		print(['MOVETO: ', position, _cursor+position])
		_cursor = _cursor + position
	
func pick_data(data, index, count):
	var points = PoolVector2Array()
	var end = index+(count*2)
	
#	if(count == 1)
#		var value1 = ((data[index-1] >> 1) ^ (-(data[index-1] & 1)))
#		var value2 = ((data[i] >> 1) ^ (-(data[n-1] & 1)))
		
	for n in range(index-1, end, 2):
		var value2 = ((data[n-2] >> 1) ^ (-(data[n-2] & 1))) * -1
		var value1 = ((data[n-1] >> 1) ^ (-(data[n-1] & 1)))
		var v = Vector2(value1, value2)
		points.append(v)
	return points;

func create_shapes():
	if(_features.empty()): return;
	for feature in _features:
		var geometry = feature.get_geometry();
		var n = 0
		while(n < geometry.size()):
			var command = geometry[n]
			var id = command & 0x7
			var count = command >> 3
			n = n + 1
			
			if(id == 1):
#				print(['MoveTo: ', count])
				var data = pick_data(geometry, n, count);
				move_to(data)
				n = n + (count * 2)
			elif(id == 2):
#				print(['LineTo: ', count])
				var data = pick_data(geometry, n, count);
#				print(['lines: ', data]);
				line_to(data)
				n = n + (count * 2)
			elif(id == 7):
#				print(['ClosePath: ', count])
				close_path()
			else:
				print(['Unknown', id, count]);
				
