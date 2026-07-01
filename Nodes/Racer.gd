extends RigidBody3D
class_name Racer


const CAMERA_SPEED = 5

@export var repulsors : RepulsorArray
@export var thrusters : Array[Thruster]
@export var chassis : Chassis

@onready var camera_pivot = $CameraPivot
@onready var camera = $CameraPivot/Camera3D

var components : Array[Component]
var camera_tracking = true
var debug_enabled = true
var look_at_point
var reset_flag = false


func _ready() -> void:
	components.append_array(thrusters)
	components.append_array(repulsors.items)
	components.append(chassis)
	mass = components.reduce(func(sum, component): return sum + component.mass, 0.0)
	look_at_point = global_position


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("camera_track"): camera_tracking = !camera_tracking


func _physics_process(delta: float) -> void:
	for force in repulsors.get_forces(linear_velocity, angular_velocity, global_position):
		#var force_origin := repulsor.force_position + global_position
		#DebugDraw3D.draw_arrow(force_origin, force_origin + repulsor.force/1000)
		apply_force(force['force'], force['position'])

	var thrust_force = Vector3()
	for thruster in thrusters:
		thrust_force += thruster.thrust * -global_transform.basis.z
	apply_central_force(thrust_force)

	var air_drag = (-linear_velocity * linear_velocity.length()) * chassis.drag_modifier
	apply_central_force(air_drag)
	
	rotate_object_local(Vector3.MODEL_FRONT, chassis.roll * delta)
	rotate_object_local(Vector3.MODEL_TOP, chassis.yaw * delta)
	rotate_object_local(Vector3.MODEL_LEFT, chassis.pitch * delta)
	
	camera_pivot.global_position = camera_pivot.global_position.lerp(global_position, delta * 20.0)
	if camera_tracking:
		look_at_point = look_at_point.lerp(global_position + (0.3*linear_velocity), delta * 5)
		var target_pivot_tranform = transform.looking_at(look_at_point)
		camera_pivot.transform = camera_pivot.transform.interpolate_with(target_pivot_tranform, delta * 5)
		camera.look_at(look_at_point)
	
	var right_stick = Input.get_vector("camera_left", "camera_right", "camera_up", "camera_down")
	camera_pivot.rotate(Vector3.DOWN, right_stick.x * delta * CAMERA_SPEED)
	camera_pivot.rotate_object_local(Vector3.FORWARD, right_stick.y * delta * CAMERA_SPEED)
	
	EventBus.spedometer_update.emit(linear_velocity.length())
	EventBus.altimeter_update.emit(global_position.y)
	
	if reset_flag: _reset()
		
	
func _reset():
	global_transform = Transform3D()
	linear_velocity = Vector3()
	angular_velocity = Vector3()
	reset_flag = false
