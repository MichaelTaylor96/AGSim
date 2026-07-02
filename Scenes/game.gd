extends Node3D

@onready var main_menu = $MainMenu
@onready var pause_menu = $PauseMenu
@onready var play_ui = $PlayUi
@onready var garage = $Garage
var current_track
var racer

func _ready() -> void:
	EventBus.start_race.connect(_start_race)
	EventBus.main_menu.connect(_open_main_menu)
	EventBus.resume.connect(_resume_play)
	EventBus.restart.connect(_restart_race)
	EventBus.garage_menu.connect(_go_to_garage)


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		if get_tree().paused: _resume_play()
		else:
			get_tree().paused = true
			pause_menu.visible = true
			pause_menu.focus()


func _start_race(track_path:String, racer_path:String, _mode:String) -> void:
	var track_resource := load(track_path)
	var track_node = track_resource.instantiate()
	var racer_resource := load(racer_path)
	var racer_node : Node
	racer_node = Racer.new()
	racer_node.build_from_resource(racer_resource)
	
	current_track = track_node
	racer = racer_node
	add_child(track_node)
	track_node.position.y -= 1
	add_child(racer_node)
	main_menu.hide()
	play_ui.show()


func _open_main_menu():
	if current_track != null: current_track.queue_free()
	if racer != null: racer.queue_free()
	main_menu.visible = true
	main_menu.focus()
	
	pause_menu.hide()
	garage.exit()
	play_ui.hide()
	get_tree().paused = false


func _resume_play():
	pause_menu.visible = false
	get_tree().paused = false


func _restart_race():
	_resume_play()
	racer.reset_flag = true


func _go_to_garage():
	main_menu.hide()
	garage.enter()
