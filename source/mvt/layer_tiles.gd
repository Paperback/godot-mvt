class_name MvtLayerTiles extends Resource

var layer: MvtLayer
export(String) var id: String = ''
export(String) var url: String = ''
export(String) var tilejson: String = 'unknown'
export(String) var version: String = ''
export(String) var attribution: String = ''
export(String) var description: String = ''
export(String) var scheme: String = 'xyz'
export(Rect2) var bounds: Rect2
export(Vector2) var center: Vector2
export(int) var minzoom: int = 0
export(int) var maxzoom: int = 11
export(int) var resolution: int = 4
export(Dictionary) var data: Dictionary = {}

func from_data(data: Dictionary):
	var keys := data.keys()
	#if keys.has('bounds') and data['bounds'].size() > 2:
	#	data['bounds'] = Rect2(data['bounds'][0], data['bounds'][1], data['bounds'][2], data['bounds'][3])
	if keys.has('center') and data['center']:
		data['center'] = Vector2(data['center'][0], data['center'][1])
	else:
		data['centre'] = Vector2() #data.bounds.position + (data.bounds.size / 2))
	for key in data.keys():
		if get(key) != null:
			set(key, data[key])
