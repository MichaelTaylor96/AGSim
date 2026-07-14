extends Node3D

var chassis_options := [
	preload("uid://baf6l75hpa6vv"),
	preload("uid://djutut5hs50j"),
	preload("uid://1duw2rwt85ru")
]
var repulsor_options := [
	preload("uid://ddjsp8evwwain"),
	preload("uid://c3slbbpdkmnfm"),
	preload("uid://bx1sfcibngsmb")
]
var thruster_options := [
	preload("uid://se0spiol5uy"),
	preload("uid://cdebyg1l404ng"),
	preload("uid://d1rlfayb6ec1b")
]
var strafe_thrust_options := [
	preload("uid://b51mgptshdtgr")
]
var repulsor_index : int = -1
var thruster_index : int = -1
var strafe_thruster_index : int = -1
var chassis : Chassis
var resource : RacerResource
@onready var ui : Control = %GarageMenu


func enter():
	show()
	ui.show()
	ui.focus()


func exit():
	hide()
	ui.hide()
	ui.clear_selections()
	get_tree().call_group("repulsor", "queue_free")
	get_tree().call_group("thruster", "queue_free")
	get_tree().call_group("strafe_thruster", "queue_free")
	get_tree().call_group("chassis", "queue_free")
	ui.non_chassis_disable_correction(true)


func _ready() -> void:
	EventBus.garage_chassis_select.connect(_on_chassis_select)
	EventBus.garage_repulsor_select.connect(_on_repulsor_select)
	EventBus.garage_thruster_select.connect(_on_thruster_select)
	EventBus.garage_strafe_select.connect(_on_strafe_select)
	EventBus.garage_save_build.connect(_on_save_build)
	resource = RacerResource.new()


func _process(delta: float) -> void:
	if chassis != null: chassis.rotate_y(1*delta)


func _on_chassis_select(chassis_id:int):
	var new_chassis : Chassis = chassis_options[chassis_id].instantiate()
	resource.chassis = chassis_options[chassis_id]
	if chassis != null:
		chassis.queue_free()
	chassis = new_chassis
	if repulsor_index > -1:
		chassis.populate_repulsors(repulsor_options[repulsor_index])
	if thruster_index > -1:
		chassis.populate_thrusters(thruster_options[thruster_index])
	if strafe_thruster_index > -1:
		chassis.populate_strafe_thrusters(strafe_thrust_options[strafe_thruster_index])
	new_chassis.add_to_group("chassis")
	add_child(chassis)


func _on_repulsor_select(repulsor_id:int):
	repulsor_index = repulsor_id
	resource.repulsor = repulsor_options[repulsor_id]
	chassis.populate_repulsors(repulsor_options[repulsor_id])


func _on_thruster_select(thruster_id:int):
	thruster_index = thruster_id
	resource.thruster = thruster_options[thruster_id]
	chassis.populate_thrusters(thruster_options[thruster_id])


func _on_strafe_select(strafe_id:int):
	strafe_thruster_index = strafe_id
	resource.strafe_thrusters = strafe_thrust_options[strafe_id]
	chassis.populate_strafe_thrusters(resource.strafe_thrusters)
	
	
func _on_save_build(build_name:String):
	if not DirAccess.dir_exists_absolute(Globals.RACERS_FOLDER):
		DirAccess.make_dir_absolute(Globals.RACERS_FOLDER)
	resource.display_name = build_name
	ResourceSaver.save(resource, Globals.RACERS_FOLDER + build_name + ".tres")
