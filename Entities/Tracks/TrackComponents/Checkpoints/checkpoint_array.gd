extends Node3D

@export var checkpoints : Array[Checkpoint]
@export var timer : Stopwatch
@onready var lap_time_label := $LapTime
@onready var last_lap_label := $LastLap
@onready var best_lap_label := $BestLap
@onready var lap_label := $Lap


var lap_start := 0.0
var current_lap := 0
var lap_time := 0.0
var last_lap := 0.0
var best_lap := 0.0
var target_checkpoint := 0
var best_lap_time := 0.


func _ready() -> void:
	for checkpoint in checkpoints:
		checkpoint.passed.connect(_on_checkpoint_passed)


func _on_checkpoint_passed(index:int, _body:Node3D):
	if index == target_checkpoint:
		target_checkpoint += 1
		lap_time = timer.time_elapsed - lap_start
		lap_time_label.text = "Lap Time: " + timer._format_time(lap_time)
		
		if target_checkpoint == len(checkpoints):
			target_checkpoint = 0
		if target_checkpoint == 1:
			current_lap += 1
			lap_label.text = "Lap: " + str(current_lap)
			
			last_lap = lap_time
			last_lap_label.text = "Last Lap: " + timer._format_time(lap_time)
			
			if last_lap < best_lap or best_lap == 0.0:
				best_lap = last_lap
				best_lap_label.text = "Best Lap: " + timer._format_time(lap_time)
			
			lap_time = 0.0
			lap_start = timer.time_elapsed
