extends Component
class_name Repulsor

@onready var ray : RayCast3D = $RayCast3D
@export var strength : float
@export var damping : float
@export var max_distance : float
var force : Vector3 = Vector3(0,0,0)
var force_scaling : float
var force_position : Vector3 = Vector3(0,0,0)


func _ready() -> void:
	ray.target_position = Vector3(0,-max_distance*2,0)


func update_force(chassis_velocity : Vector3, chassis_angular_velocity : Vector3, chassis_position : Vector3) -> void:
	ray.force_raycast_update()
	if ray.is_colliding():
		var contact := ray.get_collision_point()
		var up_dir := global_transform.basis.y
		var distance := global_position.distance_to(contact)
		var offset := max_distance - distance
		
		var spring_force = strength * offset
		
		var repulsor_velocity := chassis_velocity + chassis_angular_velocity.cross(contact - chassis_position)
		var relative_velocity := up_dir.dot(repulsor_velocity)
		var damping_force := damping * relative_velocity
		
		force = max(0, (spring_force - damping_force)) * up_dir * force_scaling
		force_position = contact - chassis_position
