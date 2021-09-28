class_name LayerIndexRequestJob extends RequestJob

var host: String
var port: String
var path: String

func _init(requester: Node, callback: String, path: String).(requester, callback):
	self.host = State.host
	self.port = State.port
	self.path = '/'+path

func _load() -> Array:
	var r: PoolByteArray = .request(host, port, path)
	response = JSON.parse(r.get_string_from_ascii()).result
	return []

var response
#func _instance(data):
#	for d in data:
#		response = d
