extends Control

const INFINITUM = "res://Scenes/Tracks/Infinitum.tscn"
const THE_DROP = "res://Scenes/Tracks/TheDrop.tscn"
const THE_LAUNCH = "res://Scenes/Tracks/TheLaunch.tscn"
const TRACKS = [INFINITUM, THE_DROP, THE_LAUNCH]

const STANDARD_RACER = "res://Scenes/Racers/StandardRacer.tscn"
const LIGHT_RACER = "res://Scenes/Racers/LightRacer.tscn"
const HEAVY_RACER = "res://Scenes/Racers/HeavyRacer.tscn"
const RACERS = [STANDARD_RACER, LIGHT_RACER, HEAVY_RACER]

@onready var track_menu := $VBoxContainer/HBoxContainer/VBoxContainer/TrackMenu
@onready var vehicle_menu := $VBoxContainer/HBoxContainer/VBoxContainer2/VehicleMenu


func _ready() -> void:
	focus()


func _on_start_button_pressed() -> void:
	var track = TRACKS[track_menu.selected]
	var racer = RACERS[vehicle_menu.selected]
	EventBus.start_race.emit(track, racer, "")


func focus():
	$VBoxContainer/BoxContainer/StartButton.grab_focus.call_deferred()
