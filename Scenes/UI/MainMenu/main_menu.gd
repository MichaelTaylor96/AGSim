extends Control

const INFINITUM = "res://Scenes/Tracks/Infinitum.tscn"
const THE_DROP = "res://Scenes/Tracks/TheDrop.tscn"
const THE_LAUNCH = "res://Scenes/Tracks/TheLaunch.tscn"
const TRACKS = [INFINITUM, THE_DROP, THE_LAUNCH]

const STANDARD_RACER = "res://Scenes/Racers/StandardRacer.tscn"
const LIGHT_RACER = "res://Scenes/Racers/LightRacer.tscn"
const HEAVY_RACER = "res://Scenes/Racers/HeavyRacer.tscn"
const CUSTOM_RACER = Globals.RACERS_FOLDER + "custom_build.tres"
const RACERS = [STANDARD_RACER, LIGHT_RACER, HEAVY_RACER, CUSTOM_RACER]

@onready var top_menu := $HBoxContainer2/TopLevel
@onready var race_menu := $HBoxContainer2/RaceMenu
@onready var track_menu := $HBoxContainer2/RaceMenu/VBoxContainer/TrackMenu
@onready var vehicle_menu := $HBoxContainer2/RaceMenu/VBoxContainer2/VehicleMenu


func _ready() -> void:
	vehicle_menu.add_item("Custom", 3)
	focus()


func focus():
	$HBoxContainer2/TopLevel/VBoxContainer/RaceButton.grab_focus.call_deferred()


func _on_start_button_pressed() -> void:
	race_menu.hide()
	top_menu.show()
	var track = TRACKS[track_menu.selected]
	var racer = RACERS[vehicle_menu.selected]
	EventBus.start_race.emit(track, racer, "")


func _on_back_button_pressed() -> void:
	race_menu.hide()
	top_menu.show()
	focus()


func _on_race_button_pressed() -> void:
	top_menu.hide()
	race_menu.show()
	$HBoxContainer2/RaceMenu/VBoxContainer/TrackMenu.grab_focus.call_deferred()


func _on_garage_button_pressed() -> void:
	EventBus.garage_menu.emit()


func _on_quit_button_pressed() -> void:
	get_tree().quit()
