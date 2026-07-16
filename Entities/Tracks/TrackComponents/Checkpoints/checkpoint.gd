extends Node3D
class_name Checkpoint

@export var index = 0
signal passed

func _on_detector_body_entered(body: Node3D) -> void:
	passed.emit(index, body)
