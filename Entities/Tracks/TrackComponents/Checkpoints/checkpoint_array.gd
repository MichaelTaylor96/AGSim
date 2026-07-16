extends Node3D

@export var checkpoints : Array[Checkpoint]
@export var timer : Stopwatch
@onready var lap_time_label := $Label
var lap_start := 0
var lap_time := 0
var current_lap := 1
var target_checkpoint := 0
var best_lap_time


func _ready() -> void:
	for checkpoint in checkpoints:
		checkpoint.passed.connect(_on_checkpoint_passed)


func _on_checkpoint_passed(index:int, body:Node3D):
	if index == target_checkpoint:
		target_checkpoint += 1
		print("hey")
		if target_checkpoint == len(checkpoints):
			target_checkpoint = 0
			current_lap += 1
			lap_time = timer.time_elapsed - lap_start
			lap_start = timer.time_elapsed
			lap_time_label.text = timer._format_time(lap_time)
