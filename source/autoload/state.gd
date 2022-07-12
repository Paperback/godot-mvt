extends Node

var project: String = ''
var folder: String = ''
var host: String = ''
var port: String = ''
var feature: Dictionary = {
	'overwrite': true,
	'pbf': true,
	'resource': true,
	'compress': false
}
func mapsdir(path: String = '') -> String:
	return folder+'/'+project+'/'+path

func url(path: String = '') -> String:
	return "http://%s:%s/%s" % [ host, port, path ]

func save_layer(layer: MvtLayer):
	layer.project = project
	var dir := mapsdir(layer.id.split('.').join('/')+'/res/layer.tres')
	#print(dir)
	var directory = Directory.new()
	if not directory.dir_exists(dir.get_base_dir()): directory.make_dir_recursive(dir.get_base_dir())
	#layer.tiles = []
	ResourceSaver.save(dir, layer, ResourceSaver.FLAG_REPLACE_SUBRESOURCE_PATHS | ResourceSaver.FLAG_CHANGE_PATH)
	
func save_tile(layer: MvtLayer, tile: MvtTile):
	var dir := mapsdir(tile.layer.id.split('.').join('/')+'/res/'+'%s/%s-%s.tres' % [tile.z, tile.x, tile.y])
#	var layer_path := mapsdir(tile.layer.id.split('.').join('/')+'/res/layer.tres')
#	var layer: MvtLayer = load(layer_path)
	var directory = Directory.new()
	if not directory.dir_exists(dir.get_base_dir()): directory.make_dir_recursive(dir.get_base_dir())
	tile.layer = layer
	ResourceSaver.save(dir, tile, ResourceSaver.FLAG_CHANGE_PATH)

func save_tile_compressed(layer: MvtLayer, tile: MvtTile):
	print('save compressed')
	var dir := mapsdir(tile.layer.id.split('.').join('/')+'/res/'+'%s/%s-%s.res' % [tile.z, tile.x, tile.y])
#	var layer_path := mapsdir(tile.layer.id.split('.').join('/')+'/res/layer.tres')
#	var layer: MvtLayer = load(layer_path)
	var directory = Directory.new()
	if not directory.dir_exists(dir.get_base_dir()): directory.make_dir_recursive(dir.get_base_dir())
	tile.layer = layer
	ResourceSaver.save(dir, tile, ResourceSaver.FLAG_COMPRESS)

func save_pbf(layer: String, filename: String, data: PoolByteArray) -> bool:
	var dir := mapsdir(layer.split('.').join('/')+'/pbf/'+filename)
	var directory = Directory.new()
	if not directory.dir_exists(dir.get_base_dir()): directory.make_dir_recursive(dir.get_base_dir())
	var file := File.new()
	var err = file.open(dir, File.WRITE_READ)
	if err != OK: 
		Log.error(err)
		Log.error(dir)
		return false
	else:
		file.store_buffer(data)
		file.close()
		return true
