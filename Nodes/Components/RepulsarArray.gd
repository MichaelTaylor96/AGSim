extends Node3D
class_name RepulsorArray

const REPULSOR_SCALE := 1000
@export var repulsors : Array[Repulsor]

func _ready() -> void:
	for repulsor : Repulsor in repulsors:
		repulsor.force_scaling = REPULSOR_SCALE
