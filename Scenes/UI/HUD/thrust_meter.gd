extends TextureProgressBar


func _ready() -> void:
	EventBus.thrust_update.connect(_on_thrust_update)
	

func _on_thrust_update(thrust_val:float):
	value = thrust_val * 100
