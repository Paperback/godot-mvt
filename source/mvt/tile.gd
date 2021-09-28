class_name MvtTile extends Resource

export(Resource) var layer: Resource
export(Resource) var tile: Resource
export(int) var x: int
export(int) var y: int
export(int) var z: int
export(Array) var geometry: Array = []

func _init(layer: Resource, tile: Resource, x: int, y: int, z: int):
	self.tile = tile
	self.layer = layer
	self.x = x
	self.y = y
	self.z = z
