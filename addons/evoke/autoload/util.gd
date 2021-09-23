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
