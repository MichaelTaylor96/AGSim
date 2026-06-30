extends Node3D
class_name RepulsorArray

const REPULSOR_SCALE := 1000
@export var items : Array[Repulsor]
var mass : float

func _ready() -> void:
	for repulsor : Repulsor in items:
		repulsor.force_scaling = REPULSOR_SCALE
		mass += repulsor.mass
		
func get_forces(linear_velocity:Vector3, angular_velocity:Vector3, racer_position:Vector3) -> Array[Dictionary]:
	var accumulator : Array[Dictionary] = []
	for repulsor in items:
		repulsor.update_force(linear_velocity, angular_velocity, racer_position)
		accumulator.append({
			"force": repulsor.force,
			"position": repulsor.force_position
		})
	return accumulator
