extends Control

const INFINITUM = "res://Entities/Tracks/Infinitum.tscn"
const THE_DROP = "res://Entities/Tracks/TheDrop.tscn"
const THE_LAUNCH = "res://Entities/Tracks/TheLaunch.tscn"
const TRACKS = [INFINITUM, THE_DROP, THE_LAUNCH]
var racers : Array[String] = []

@onready var top_menu := $HBoxContainer2/TopLevel
@onready var race_menu := $HBoxContainer2/RaceMenu
@onready var track_menu := $HBoxContainer2/RaceMenu/VBoxContainer/TrackMenu
@onready var vehicle_menu := $HBoxContainer2/RaceMenu/VBoxContainer2/VehicleMenu


func _ready() -> void:
	focus()


func focus():
	$HBoxContainer2/TopLevel/VBoxContainer/RaceButton.grab_focus.call_deferred()


func _on_start_button_pressed() -> void:
	race_menu.hide()
	top_menu.show()
	var track = TRACKS[track_menu.selected]
	var racer = racers[vehicle_menu.selected]
	EventBus.start_race.emit(track, racer, "")


func _on_back_button_pressed() -> void:
	race_menu.hide()
	top_menu.show()
	focus()


func _on_race_button_pressed() -> void:
	top_menu.hide()
	racers.clear()
	vehicle_menu.clear()
	var index := 0
	for resource_file in DirAccess.get_files_at("res://World/Resources/Racers"):
		var path = "res://World/Resources/Racers/" + resource_file
		var racer : RacerResource = load(path)
		racers.append(path)
		vehicle_menu.add_item(racer.display_name, index)
		index += 1
	#for resource_file in DirAccess.get_files_at(Globals.RACERS_FOLDER):
		#var path = Globals.RACERS_FOLDER + resource_file
		#var racer : RacerResource = load(path)
		#racers.append(path)
		#vehicle_menu.add_item(racer.display_name, index)
		#index += 1
	race_menu.show()
	$HBoxContainer2/RaceMenu/VBoxContainer/TrackMenu.grab_focus.call_deferred()


func _on_garage_button_pressed() -> void:
	EventBus.garage_menu.emit()


func _on_quit_button_pressed() -> void:
	get_tree().quit()
