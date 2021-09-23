extends Node

var title = ProjectSettings.get_setting("application/config/name")
var version = ProjectSettings.get_setting("application/config/version")
var environment = ProjectSettings.get_setting("application/config/environment")

func _init():
	Log.verbose("Application: initialized")
	Log.info("Application: %s initialized" % title)
#	TranslationServer.set_locale("en")
#	Translation.locale = "en"
	Log.info("Application: version: %s" % version)
	Log.info("Application: environment %s" % environment)
	if production():
		Log.supress(Log.LEVEL.VERBOSE)

func production():
	return environment == "production"

func development():
	return environment == "development"

func testing():
	return environment == "test"

func exit():
	get_tree().free()
