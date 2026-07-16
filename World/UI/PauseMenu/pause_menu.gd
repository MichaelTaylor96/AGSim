extends Control


func focus():
	$VBoxContainer/Resume.grab_focus()


func _on_resume_pressed() -> void:
	print("HEY")
	EventBus.resume.emit()


func _on_restart_pressed() -> void:
	EventBus.restart.emit()


func _on_main_menu_pressed() -> void:
	EventBus.main_menu.emit()
