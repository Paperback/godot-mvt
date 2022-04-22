extends Node

var uri: String = ""
var project: String = ""
onready var layers = $"../Layers"

func _http_layer_info_request_completed(result, response_code, headers, body):
	var response = parse_json(body.get_string_from_utf8())
	layers.update(response.name, 'tile', response)
	layers.update(response.name, 'project', project)
	#response.maxzoom = 6
	print(response.maxzoom)
	print(response.minzoom)
	for z in range(response.minzoom, response.maxzoom):
		for x in range(0, pow(z, 2)):
			for y in range(0, pow(z, 2)):
				_on_Layer_request(layers.layers[response.name], x, y, z)

var left: int = 0
func _http_layer_pbf_request_completed(result, response_code, headers, body, layer, tile, x, y, z):
	layer.set_meta('left', layer.get_meta('left')-1)
	layers.import(layer.id, tile, x, y, z)
	layers.emit_signal("layer_updated", layer)

func _on_Layers_informed(layer: MvtLayer):
	var request = HTTPRequest.new()
	request.use_threads = true
	add_child(request)
	request.connect("request_completed", self, "_http_layer_info_request_completed")
	Log.verbose("Request layer: %s " % layer.id)
	var error = request.request(uri + '/' + layer.id + '.json')
	if error != OK:
		Log.info(error)
		Log.fatal("HTTP Request failed: %s" % uri + '/' + layer.id + '.json')

func _on_Layer_request(layer: MvtLayer, x: int, y: int, z:int):
	for tile in layer.tile.tiles:
		var location: String = tile.format({
			'x': x,
			'y': y,
			'z': z
		})
		_on_Layer_Tile_request(layer, x, y, z, location)

func _on_Layer_Tile_request(layer: MvtLayer, x: int, y: int, z: int, location: String):
	var request = HTTPRequest.new()
	request.use_threads = true
	var path = "%s/%s/pbf/%s/%s-%s.pbf" % [project, layer.table, z, x, y]
	if not layer.has_meta('count'): 
		layer.set_meta('count', 0)
		layer.set_meta('left', 0)
	layer.set_meta('count', layer.get_meta('count')+1)
	layer.set_meta('left', layer.get_meta('left')+1)
	#Log.verbose(path)
	var dir := Directory.new()
	dir.make_dir_recursive("%s/%s/pbf/%s" % [project, layer.table, z])
	request.download_file = path
	add_child(request)
	request.connect("request_completed", self, "_http_layer_pbf_request_completed", [layer, path, x, y, z])
	#Log.verbose("Request layer tile: %s " % location)
	var error = request.request(location)
	if error != OK:
		Log.info(error)
		Log.fatal("HTTP Request failed: %s" % uri + '/' + layer.id + '.json')
