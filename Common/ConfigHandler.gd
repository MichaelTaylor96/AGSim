extends Node


var config : ConfigFile = ConfigFile.new()
const SETTINGS_PATH = "user://racers.ini"


func _ready() -> void:
	if !FileAccess.file_exists(SETTINGS_PATH):
		config.set_value("audio", "master_volume", 0.5)
		config.set_value("audio", "music_volume", 0.5)
		config.set_value("audio", "sfx_volume", 0.5)
		config.save(SETTINGS_PATH)
	else:
		config.load(SETTINGS_PATH)


func save_audio_settings(key : String, value : Variant) -> void:
	config.set_value("audio", key, value)
	config.save(SETTINGS_PATH)
	

func load_audio_settings() -> Dictionary:
	var audio_settings : Dictionary = {}
	for key in config.get_section_keys("audio"):
		audio_settings[key] = config.get_value("audio", key)
	return audio_settings


func save_controls_settings(key : String, value : Variant) -> void:
	config.set_value("controls", key, value)
	config.save(SETTINGS_PATH)


func load_controls_settings() -> Dictionary:
	var controls_settings : Dictionary = {}
	for key in config.get_section_keys("controls"):
		controls_settings[key] = config.get_value("controls", key)
	return controls_settings
