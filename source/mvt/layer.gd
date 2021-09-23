class_name MvtLayer extends Resource

export(String) var project: String
export(String) var id: String
export(String) var schema: String = 'public'
export(String) var table: String
export(String) var id_column: String
export(String) var geometry_column: String = 'geom'
export(int) var srid: int = 4326
export(int) var extent: int = 4096
export(bool) var clip_geom: bool = false
export(String) var geometry_type: String = 'GEOMETRY'
export(Dictionary) var properties = {}
export(Dictionary) var tile = {}
export(Array) var tiles = []

func _init(data: Dictionary):
	for key in data.keys():
		if get(key) != null:
			set(key, data[key])
