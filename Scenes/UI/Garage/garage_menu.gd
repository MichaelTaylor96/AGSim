extends Control

@onready var repulsor_options := $EditMenu/RepulsorOptions
@onready var thruster_options := $EditMenu/ThrusterOptions
@onready var aux_options := $EditMenu/AuxOptions
@onready var chassis_options := $EditMenu/ChassisOptions
@onready var non_chassis_comps : Array[OptionButton] = [
	$EditMenu/RepulsorOptions,
	$EditMenu/ThrusterOptions,
	$EditMenu/AuxOptions
]
@onready var edit_menu := $EditMenu
@onready var garage_menu := $TopLevel


func focus():
	$TopLevel/VBoxContainer/EditButton.grab_focus.call_deferred()


func disable_aux():
	aux_options.select(-1)
	aux_options.disabled = true


func enable_aux():
	aux_options.select(-1)
	aux_options.disabled = false


func clear_selections():
	chassis_options.select(-1)
	repulsor_options.select(-1)
	thruster_options.select(-1)
	aux_options.select(-1)


func _ready() -> void:
	focus()


func _on_chassis_options_item_selected(index: int) -> void:
	for dropdown in non_chassis_comps:
		dropdown.disabled = index == -1
	EventBus.garage_chassis_select.emit(index)


func _on_repulsor_options_item_selected(index: int) -> void:
	EventBus.garage_repulsor_select.emit(index)


func _on_thruster_options_item_selected(index: int) -> void:
	EventBus.garage_thruster_select.emit(index)


func _on_aux_options_item_selected(index: int) -> void:
	EventBus.garage_aux_select.emit(index)


func _on_edit_back_button_pressed() -> void:
	edit_menu.hide()
	garage_menu.show()
	$TopLevel/VBoxContainer/EditButton.grab_focus.call_deferred()


func _on_edit_button_pressed() -> void:
	garage_menu.hide()
	edit_menu.show()
	$EditMenu/ChassisOptions.grab_focus.call_deferred()


func _on_main_menu_pressed() -> void:
	EventBus.main_menu.emit()
