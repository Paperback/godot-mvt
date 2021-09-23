class_name Job extends Reference

var requester: Node
var staging_node: Node
var callback_func: String
var batch := 1000
var to_instance_ := []

func _init(requester: Node, callback_func: String) -> void:
	self.requester = requester
	self.callback_func = callback_func

func __load() -> void:
	to_instance_ = _load()

func _load() -> Array:
	return []

func _add_staging_node() -> void:
	staging_node = Node2D.new()
	requester.add_child(staging_node)

func _remove_staging_node() -> void:
	staging_node.get_parent().remove_child(staging_node)

func _instance(to_instance):
	pass

func __instance():
	if not to_instance_: return yield()
	for i in range(to_instance_.size()):
		if i % batch == 0:
			yield()
		
		_instance(to_instance_[i])

func _on_requester_invalid() -> void:
	pass
