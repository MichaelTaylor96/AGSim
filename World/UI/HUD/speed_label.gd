extends Label


const MIN_ANGLE = -120
const MAX_ANGLE = 120


func _ready() -> void:
	EventBus.spedometer_update.connect(_on_speed_update)
	

func _on_speed_update(speed:float):
	text = "%.1f mph" % (speed*2.2369)
