extends TextureRect


func _ready() -> void:
	EventBus.boost_update.connect(_on_boost_update)
	

func _on_boost_update(boost_val:bool):
	visible = boost_val
