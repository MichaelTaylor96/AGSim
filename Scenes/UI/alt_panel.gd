extends Panel


const MIN_ANGLE = -120
const MAX_ANGLE = 120
@export var max_altitude = 100


func _ready() -> void:
	EventBus.altimeter_update.connect(_on_altitude_update)
	

func _on_altitude_update(altitude:float):
	rotation_degrees = MIN_ANGLE + ((MAX_ANGLE - MIN_ANGLE) * (altitude/max_altitude))
