extends TextureProgressBar


func _ready() -> void:
	EventBus.temp_update.connect(_on_temp_update)
	

func _on_temp_update(temp_val:float):
	value = temp_val * 100
