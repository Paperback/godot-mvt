extends Node

func _init():
	Log.verbose("Util: initialized")

static func merge(target, patch):
	for key in patch:
		target[key] = patch[key]

static func gen_string(length: int) -> String:
	var ascii_letters_and_digits = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"	
	var result = ""
	for i in range(length):
		result += ascii_letters_and_digits[randi() % ascii_letters_and_digits.length()]
	return result

static func from_url(url: String) -> Dictionary:
	var scheme := 'http'
	var host := ''
	var port := 80
	var path := ''
	
	if url.begins_with('http://'):
		url = url.lstrip('http://')
	elif url.begins_with('https://'):
		scheme = 'https'
		url = url.lstrip('https://')
	
	var split = url.split(':')
	host = split[0]
	port = int(split[1])
	split = url.split('/')
	split.remove(0)
	path = split.join('/')
	
	return {
		'scheme': scheme,
		'host': host,
		'port': port,
		'path': path,
		'url': '%s://%s:%s/%s' % [scheme, host, port, path]
	}
