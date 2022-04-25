class_name MvtGeometry extends Resource

export(Array) var type: Array
export(Array) var data: Array
export(Array) var properties: Array

func _init():
	type = []
	data = []
	properties = []

func submit(t: String, geom: Array, props: Dictionary = {}):
	type.push_back(t)
	data.push_back(geom)
	properties.push_back(props)

func empty() -> bool:
	return data.size() == 0

func size() -> int:
	return data.size()

func get_index(index: int) -> Dictionary:
	return {
		'type': type[index],
		'data': data[index],
		'properties': properties[index]
	}
