extends RigidBody3D
class_name Chassis

@onready var camera = $CameraPivot
@onready var repulsors = $RepulsorArray
@onready var thruster = $Thruster
@onready var boost_flame = $BoostFlame
@onready var thrust_flame = $StandardFlame
const CROSS_AREA = 2.5
var drag_coefficient = 0.4
@export var yaw_speed = 3
@export var pitch_speed = 2
@export var roll_speed = 2
const REPULSOR_SCALE = 500
const CAMERA_SPEED = 5
const AIR_BRAKE = 50
var camera_tracking = true
var debug_enabled = true

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("camera_track"): camera_tracking = !camera_tracking

func _physics_process(delta: float) -> void:
	for repulsor in repulsors.get_children():
		_apply_repulsor_force(repulsor)

	var thruster_val = Input.get_action_strength("thrust")
	thrust_flame.visible = thruster_val > 0
	var thrust_max = thruster.max_thrust
	if Input.is_action_pressed("boost"): thrust_max += thruster.boost_modifier
	boost_flame.visible = Input.is_action_pressed("boost")
	var air_brake_val = Input.get_action_strength("air_brake")
	var thrust_force = thrust_max * thruster_val * global_transform.basis.x
	apply_central_force(thrust_force)
	
	var air_drag = (-linear_velocity * linear_velocity.length()) * drag_coefficient * CROSS_AREA * (1.225/2)
	air_drag *= AIR_BRAKE * air_brake_val
	apply_central_force(air_drag)
		
	var yaw = Input.get_axis("steer_right", "steer_left") * yaw_speed
	var pitch = Input.get_axis("pitch_down", "pitch_up") * pitch_speed
	var roll = Input.get_axis("roll_right", "roll_left") * roll_speed
	
	rotate_object_local(Vector3.MODEL_RIGHT, roll * delta)
	rotate_object_local(Vector3.MODEL_TOP, yaw * delta)
	rotate_object_local(Vector3.MODEL_FRONT, pitch * delta)
	
	camera.global_position = camera.global_position.lerp(global_position, delta * 20.0)
	if camera_tracking: camera.transform = camera.transform.interpolate_with(transform, delta * 5)
	
	var right_stick = Input.get_vector("camera_left", "camera_right", "camera_up", "camera_down")
	camera.rotate(Vector3.DOWN, right_stick.x * delta * CAMERA_SPEED)
	camera.rotate_object_local(Vector3.FORWARD, right_stick.y * delta * CAMERA_SPEED)


func _get_point_velocity(point:Vector3) -> Vector3:
	return linear_velocity + angular_velocity.cross(point - global_position)


func _apply_repulsor_force(repulsor:Repulsor) -> void:
	repulsor.ray.force_raycast_update()
	if repulsor.ray.is_colliding():
		var contact := repulsor.ray.get_collision_point()
		var up_dir := repulsor.global_transform.basis.y
		var distance := repulsor.global_position.distance_to(contact)
		var offset := repulsor.max_distance - distance
		
		var spring_force = repulsor.strength * offset
		
		var repulsor_velocity := _get_point_velocity(contact)
		var relative_velocity := up_dir.dot(repulsor_velocity)
		var damping_force := repulsor.damping * relative_velocity
		
		var force_vector = max(0, (spring_force - damping_force)) * up_dir * REPULSOR_SCALE
		var spring_vector = spring_force * up_dir * REPULSOR_SCALE
		var damp_vector = damping_force * up_dir * REPULSOR_SCALE
		
		var force_position = contact - global_position
		apply_force(force_vector, force_position)
