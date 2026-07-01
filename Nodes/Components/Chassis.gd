extends Component
class_name Chassis

@export var cross_area := 2.5
@export var drag_coefficient := 0.4
@export var yaw_speed := 3.0
@export var pitch_speed := 2.0
@export var roll_speed := 2.0
@export var air_brake := 50
@export var collision_shape : String
@export var angular_damp : float
@export var auxiliary_thruster_mounts : Array[Transform3D]
@export var thruster_mounts : Array[Transform3D]
@export var repulsor_mounts : Array[Transform3D]


var drag_modifier := 0.0
var roll := 0.0
var pitch := 0.0
var yaw := 0.0


func _process(_delta: float) -> void:
	var air_brake_val = Input.get_action_strength("air_brake")
	drag_modifier = drag_coefficient * cross_area * (1.225/2) * air_brake * air_brake_val
		
	yaw = Input.get_axis("steer_right", "steer_left") * yaw_speed
	pitch = Input.get_axis("pitch_down", "pitch_up") * pitch_speed
	roll = Input.get_axis("roll_right", "roll_left") * roll_speed


func populate_repulsors(resource:Resource) -> Array[Repulsor]:
	if is_inside_tree(): get_tree().call_group("repulsor", "queue_free")
	var repulsors : Array[Repulsor] = []
	for mount in repulsor_mounts:
		var new_node : Repulsor = resource.instantiate()
		new_node.transform = mount
		new_node.add_to_group("repulsor")
		add_child(new_node)
		repulsors.append(new_node)
	return repulsors


func populate_thrusters(resource:Resource) -> Array[Thruster]:
	if is_inside_tree(): get_tree().call_group("thruster", "queue_free")
	var thrusters : Array[Thruster] = []
	for mount in thruster_mounts:
		var new_node : Thruster = resource.instantiate()
		new_node.transform = mount
		new_node.add_to_group("thruster")
		add_child(new_node)
		thrusters.append(new_node)
	return thrusters


func populate_auxiliary_thrusters(resource:Resource) -> Array[Thruster]:
	if is_inside_tree(): get_tree().call_group("auxiliary_thruster", "queue_free")
	var aux_thrusts : Array[Thruster] = []
	for mount in auxiliary_thruster_mounts:
		var new_node : Thruster = resource.instantiate()
		new_node.transform = mount
		new_node.add_to_group("auxiliary_thruster")
		add_child(new_node)
		aux_thrusts.append(new_node)
	return aux_thrusts
