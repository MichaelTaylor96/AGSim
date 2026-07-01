extends Node3D

var chassis_options := [
	preload("res://Scenes/Components/Chassis/StarterChassis.tscn"),
	preload("res://Scenes/Components/Chassis/LightChassis.tscn"),
	preload("res://Scenes/Components/Chassis/HeavyChassis.tscn")
]
var repulsor_options := [
	preload("res://Scenes/Components/Repulsors/StarterRepulsors.tscn"),
	preload("res://Scenes/Components/Repulsors/SoftRepulsor.tscn"),
	preload("res://Scenes/Components/Repulsors/StrongRepulsor.tscn")
]
var thruster_options := [
	preload("res://Scenes/Components/Thrusters/StarterThruster.tscn"),
	preload("res://Scenes/Components/Thrusters/LightThruster.tscn"),
	preload("res://Scenes/Components/Thrusters/HeavyThruster.tscn")
]
var aux_thrust_options := [
	preload("res://Scenes/Components/Thrusters/AuxiliaryThruster.tscn")
]
var repulsor_index : int = -1
var thruster_index : int = -1
var auxiliaries_index : int = -1
var chassis : Chassis
@onready var ui : Control = $GarageMenu


func enter():
	show()
	ui.show()
	ui.focus()


func exit():
	hide()
	ui.hide()
	ui.clear_selections()
	get_tree().call_group("repulsors", "queue_free")
	get_tree().call_group("thrusters", "queue_free")
	get_tree().call_group("aux_thrusts", "queue_free")
	get_tree().call_group("chassis", "queue_free")


func _populate_mounts(resource:Resource, mounts:Array[Transform3D], group:String):
	for mount in mounts:
		var new_node = resource.instantiate()
		new_node.transform = mount
		new_node.add_to_group(group)
		chassis.add_child(new_node)


func _ready() -> void:
	EventBus.garage_chassis_select.connect(_on_chassis_select)
	EventBus.garage_repulsor_select.connect(_on_repulsor_select)
	EventBus.garage_thruster_select.connect(_on_thruster_select)
	EventBus.garage_aux_select.connect(_on_auxiliary_select)


func _process(delta: float) -> void:
	if chassis != null: chassis.rotate_y(1*delta)


func _on_chassis_select(chassis_id:int):
	var new_chassis : Chassis = chassis_options[chassis_id].instantiate()
	if chassis != null:
		chassis.queue_free()
	chassis = new_chassis
	if repulsor_index > -1:
		_populate_mounts(repulsor_options[repulsor_index], chassis.repulsor_mounts, "repulsors")
	if thruster_index > -1:
		_populate_mounts(thruster_options[thruster_index], chassis.thruster_mounts, "thrusters")
	if auxiliaries_index > -1:
		_populate_mounts(aux_thrust_options[0], chassis.auxiliary_thruster_mounts, "aux_thrusts")
	if chassis.auxiliary_thruster_mounts.is_empty(): ui.disable_aux()
	else: ui.enable_aux()
	new_chassis.add_to_group("chassis")
	add_child(chassis)


func _on_repulsor_select(repulsor_id:int):
	get_tree().call_group("repulsors", "queue_free")
	repulsor_index = repulsor_id
	_populate_mounts(repulsor_options[repulsor_id], chassis.repulsor_mounts, "repulsors")


func _on_thruster_select(thruster_id:int):
	get_tree().call_group("thrusters", "queue_free")
	thruster_index = thruster_id
	_populate_mounts(thruster_options[thruster_id], chassis.thruster_mounts, "thrusters")


func _on_auxiliary_select(aux_id:int):
	get_tree().call_group("aux_thrusts", "queue_free")
	auxiliaries_index = aux_id
	_populate_mounts(aux_thrust_options[aux_id], chassis.auxiliary_thruster_mounts, "aux_thrusts")
