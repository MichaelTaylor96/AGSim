extends Panel


const MIN_ANGLE = -120
const MAX_ANGLE = 120
@export var max_thrust = 2000


func _ready() -> void:
	EventBus.thrust_update.connect(_on_thrust_update)
	

func _on_thrust_update(thrust_val:float):
	rotation_degrees = MIN_ANGLE + ((MAX_ANGLE - MIN_ANGLE) * thrust_val)
