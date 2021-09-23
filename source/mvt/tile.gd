class_name MvtTile extends Resource

export(Resource) var layer: Resource
export(Vector2) var position := Vector2()
export(int) var zoom: int
export(Array) var geometry := []

func _init(layer, x, y, z):
	self.layer = layer
	position = Vector2(x,y)
	zoom = z
