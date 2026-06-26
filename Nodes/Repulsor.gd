extends Node3D
class_name Repulsor

@onready var ray : RayCast3D = $RayCast3D
@export var strength : float
@export var damping : float
@export var max_distance : float
@export var force : Vector3 = Vector3(0,0,0)

func _ready() -> void:
	ray.target_position = Vector3(0,-max_distance*2,0)
