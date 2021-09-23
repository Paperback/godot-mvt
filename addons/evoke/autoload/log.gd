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
	var _file := File.new()
	var _path
	var _open := false
	var _buffer := PoolStringArray()
	var _buffer_size setget resize
	var _buffer_i := 0
	var _printing := true
	var _active := true
	var _supress_level := -100 # log all levels

	func _init(l) -> void:
		_path = l
		resize(LOG_BUFFER_SIZE)
		write("Log: initialized", LEVEL.VERBOSE)

	func supress(level) -> void:
		write("Log: surpress " + str(level), LEVEL.VERBOSE)
		_supress_level = level

	func release() -> void:
		if _active:
			write("Log: release", LEVEL.INFO)
			flush()
			_active = false

	func resize(size) -> void:
		_buffer_size = size
		_buffer.resize(size)

	func path() -> String:
		return "user://" + _path

	func mode() -> int:
		if missing():
			return File.WRITE # create
		else:
			return File.READ_WRITE # append

	func exists() -> bool:
		var exists = File.new()
		exists = exists.file_exists(path())
		return exists

	func missing() -> bool:
		return !exists()

	func open() -> bool:
		if not _active:
			_open = false
			return false;
		if not _open:
			_file = File.new()
			if _file.open(path(), mode()):
				_file.seek_end()
			else:
				return true
			_open = true
			return true
		return false

	func close() -> void:
		_file.close()
		_open = false

	func flush() -> void:
		if _buffer_i == 0:
			return
		var opened := open()
		if opened:
			for i in range(_buffer_i):
				_file.store_line(_buffer[i])
		close()
		_buffer_i = 0

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
		_buffer[_buffer_i] = rendered
		_buffer_i += 1

		if _buffer_i == _buffer_size:
			flush()
		if level >= LEVEL.INFO:
			flush()
		if _printing:
			print(rendered)

var logger
func _init():
	logger = Log.new("application.log")

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
