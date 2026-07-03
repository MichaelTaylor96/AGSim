extends TextureRect


const MIN_ANGLE = -120
const MAX_ANGLE = 120
@export var max_speed = 500/2.2369


func _ready() -> void:
	EventBus.spedometer_update.connect(_on_speed_update)
	

func _on_speed_update(speed:float):
	rotation_degrees = MIN_ANGLE + ((MAX_ANGLE - MIN_ANGLE) * (speed/max_speed))
