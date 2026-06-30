extends Panel


const MIN_ANGLE = -120
const MAX_ANGLE = 120
@export var max_speed = 150


func _ready() -> void:
	EventBus.spedometer_update.connect(_on_speed_update)
	

func _on_speed_update(speed:float):
	rotation_degrees = MIN_ANGLE + ((MAX_ANGLE - MIN_ANGLE) * (speed/max_speed))
