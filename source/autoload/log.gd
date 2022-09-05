extends Node

const LOG_BUFFER_SIZE = 128
const LOG_FORMAT = "{DATE} {TIME} {TICKS}, {LEVEL}, {MESSAGE}"
enum LEVEL {
	VERBOSE,
	INFO,
	WARNING,
	ERROR,
	FATAL
}

class Log:
	var _supress_level := -100 # log all levels

	func _init() -> void:
		write("Log: initialized", LEVEL.VERBOSE)

	func supress(level) -> void:
		write("Log: surpress " + str(level), LEVEL.VERBOSE)
		_supress_level = level

	func _render(message, level):
		var ticks = OS.get_ticks_msec()
		var datetime = OS.get_datetime()
		var date = "%s/%s/%s" % [datetime.year, datetime.month, datetime.day]
		var time = "%s:%s:%s" % [datetime.hour, datetime.minute, datetime.second]
		var level_name = LEVEL.keys()[level]
		var rendered = LOG_FORMAT
		rendered = rendered.replace("{LVL}", level)
		rendered = rendered.replace("{LEVEL}", level_name)
		rendered = rendered.replace("{MESSAGE}", message)
		rendered = rendered.replace("{TICKS}", ticks)
		rendered = rendered.replace("{DATE}", date)
		rendered = rendered.replace("{TIME}", time)
		return rendered

	func write(message, level = LEVEL.INFO):
		if level < _supress_level:
			return
		var rendered = _render(message, level)
		print(rendered)

var logger
func _init():
	logger = Log.new()

func _notification(what):
	if what == NOTIFICATION_PREDELETE:
		logger.release()

func _exit_tree():
	logger.release()

func supress(lvl):
	logger.supress(lvl)

func fatal(message):
	logger.write(message, LEVEL.FATAL)
	assert(message)

func error(message):
	logger.write(message, LEVEL.ERROR)
	push_error(message)

func warning(message):
	logger.write(message, LEVEL.WARNING)
	push_warning(message)

func info(message):
	logger.write(message, LEVEL.INFO)

func verbose(message):
	logger.write(message, LEVEL.VERBOSE)
