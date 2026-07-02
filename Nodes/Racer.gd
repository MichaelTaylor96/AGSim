extends RigidBody3D
class_name Racer

const CAMERA_SPEED = 5

@export var repulsors : Array[Repulsor]
@export var thrusters : Array[Thruster]
@export var chassis : Chassis

@onready var camera_pivot = $CameraPivot
@onready var camera = $CameraPivot/Camera3D

var components : Array[Component]
var camera_tracking = true
var debug_enabled = true
var look_at_point
var reset_flag = false


func build_from_resource(resource:RacerResource):
	chassis = resource.chassis.instantiate()
	repulsors = chassis.populate_repulsors(resource.repulsor)
	thrusters = chassis.populate_thrusters(resource.thruster)
	if resource.auxiliary_thrusters != null:
		thrusters.append_array(chassis.populate_auxiliary_thrusters(resource.auxiliary_thrusters))
	angular_damp = chassis.angular_damp
	add_child(chassis)

	var collision_shape = load(chassis.collision_shape).instantiate()
	add_child(collision_shape)

	camera_pivot = load("res://Scenes/Components/camera.tscn").instantiate()
	add_child(camera_pivot)


func _ready() -> void:
	components.append_array(thrusters)
	components.append_array(repulsors)
	components.append(chassis)
	mass = components.reduce(func(sum, component): return sum + component.mass, 0.0)
	look_at_point = global_position


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("camera_track"): camera_tracking = !camera_tracking


func _physics_process(delta: float) -> void:
	for repulsor in repulsors:
		repulsor.update_force(linear_velocity, angular_velocity, global_position)
		#var force_origin := repulsor.force_position + global_position
		#DebugDraw3D.draw_arrow(force_origin, force_origin + repulsor.force/1000)
		apply_force(repulsor.force, repulsor.force_position)

	var thrust_force = Vector3()
	for thruster in thrusters:
		thrust_force += thruster.thrust * -global_transform.basis.z
	apply_central_force(thrust_force)
	
	rotate_object_local(Vector3.MODEL_FRONT, chassis.roll * delta)
	rotate_object_local(Vector3.MODEL_TOP, chassis.yaw * delta)
	rotate_object_local(Vector3.MODEL_LEFT, chassis.pitch * delta)

	var backward = transform.basis.z
	var drag_direction = -linear_velocity.normalized()
	var alignment_arc = Quaternion().slerp(Quaternion(backward, drag_direction), 0.5)
	var air_drag = (linear_velocity.length()**2) * chassis.drag_modifier * drag_direction
	air_drag = alignment_arc * air_drag
	#DebugDraw3D.draw_line(global_position, global_position + air_drag.normalized()*3)
	
	apply_central_force(air_drag)
	
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
