class_name IndexRequestJob extends RequestJob

var host: String
var port: int
var path: String

func _init(requester: Node, callback: String, host: String, port: int, path: String).(requester, callback):
	self.host = host
	self.port = port
	self.path = path

func _load() -> Array:
	return [{
		'response': .requestJSON(host, str(port), path)
	}]
