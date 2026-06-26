extends RigidBody3D
class_name Racer

@export var array : RepulsorArray
@export var thruster : Thruster
@export var chassis : Chassis

@onready var camera = $CameraPivot
var components : Array[Component]
const CAMERA_SPEED = 5
var camera_tracking = true
var debug_enabled = true


func _ready() -> void:
	components.append_array([thruster, chassis])
	components.append_array(array.repulsors)
	mass = components.reduce(func(sum, component): return sum + component.mass, 0.0)
	print(mass)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("camera_track"): camera_tracking = !camera_tracking


func _physics_process(delta: float) -> void:
	for repulsor : Repulsor in array.repulsors:
		repulsor.update_force(linear_velocity, angular_velocity, global_position)
		#DebugDraw3D.draw_arrow(repulsor.force_position, repulsor.force_position + repulsor.force)
		apply_force(repulsor.force, repulsor.force_position)

	var thrust_force = thruster.thrust * global_transform.basis.x
	apply_central_force(thrust_force)

	var air_drag = (-linear_velocity * linear_velocity.length()) * chassis.drag_modifier
	apply_central_force(air_drag)
	
	rotate_object_local(Vector3.MODEL_RIGHT, chassis.roll * delta)
	rotate_object_local(Vector3.MODEL_TOP, chassis.yaw * delta)
	rotate_object_local(Vector3.MODEL_FRONT, chassis.pitch * delta)
	
	camera.global_position = camera.global_position.lerp(global_position, delta * 20.0)
	if camera_tracking: camera.transform = camera.transform.interpolate_with(transform, delta * 5)
	
	var right_stick = Input.get_vector("camera_left", "camera_right", "camera_up", "camera_down")
	camera.rotate(Vector3.DOWN, right_stick.x * delta * CAMERA_SPEED)
	camera.rotate_object_local(Vector3.FORWARD, right_stick.y * delta * CAMERA_SPEED)
	
