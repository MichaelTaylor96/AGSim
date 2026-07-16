extends RigidBody3D
class_name Racer

const CAMERA_SPEED = 5

@export var repulsors : Array[Repulsor]
@export var thrusters : Array[Thruster]
@export var strafe_thrusters : Dictionary[String, StrafeThruster]
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
	strafe_thrusters = chassis.populate_strafe_thrusters(resource.strafe_thrusters)
	angular_damp = chassis.angular_damp
	add_child(chassis)

	var collision_shape = load(chassis.collision_shape).instantiate()
	add_child(collision_shape)

	camera_pivot = load("res://Entities/Racer/camera.tscn").instantiate()
	add_child(camera_pivot)


func _ready() -> void:
	print(center_of_mass)
	components.append_array(thrusters)
	components.append_array(repulsors)
	components.append(chassis)
	mass = components.reduce(func(sum, component): return sum + component.mass, 0.0)
	center_of_mass_mode = RigidBody3D.CENTER_OF_MASS_MODE_CUSTOM
	center_of_mass = Vector3(0,0,0)
	inertia = Vector3(mass, mass, mass)
	look_at_point = global_position
	continuous_cd = true


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("camera_track"): camera_tracking = !camera_tracking


func _draw_force(force:Vector3, color:Color, origin:=Vector3(0,0,0)):
	if origin.length() == 0: origin = transform * Vector3.MODEL_TOP
	DebugDraw3D.draw_line(origin, origin+force, color)


func _physics_process(delta: float) -> void:
	for repulsor in repulsors:
		repulsor.update_force(linear_velocity, angular_velocity, global_position)
		if debug_enabled:
			var force_origin := repulsor.force_position + global_position
			_draw_force(repulsor.force/10000, Color.BLUE, force_origin)
		apply_force(repulsor.force, repulsor.force_position)

	var thrust_force = Vector3()
	for thruster in thrusters:
		thrust_force += -global_transform.basis.z * thruster.thrust
	if debug_enabled: _draw_force(thrust_force/10000, Color.RED)
	apply_central_force(thrust_force)
	
	apply_torque(transform.basis * (Vector3.MODEL_FRONT * chassis.roll * 5000))
	apply_torque(transform.basis * (Vector3.MODEL_TOP * chassis.yaw * 5000))
	apply_torque(transform.basis * (Vector3.MODEL_LEFT * chassis.pitch * 5000))

	var strafe_dir := Input.get_axis("strafe_right", "strafe_left")
	var strafer := strafe_thrusters["right"] if strafe_dir == 1 else strafe_thrusters["left"]
	var strafe_force = transform.basis*(strafe_dir*Vector3.MODEL_RIGHT*strafer.thrust)
	strafe_thrusters["right"].thrust_visual.visible = strafe_dir == 1
	strafe_thrusters["left"].thrust_visual.visible = strafe_dir == -1
	if debug_enabled: _draw_force(strafe_force/5000, Color.RED)
	apply_central_force(strafe_force)
	
	var backward = transform.basis.z
	var drag_direction = -linear_velocity.normalized()
	var alignment_arc = Quaternion().slerp(Quaternion(backward, drag_direction), 0.25)
	var air_drag = (linear_velocity.length()**2) * chassis.drag_modifier * drag_direction
	air_drag = alignment_arc * air_drag
	if debug_enabled: _draw_force(air_drag/5000, Color.GREEN_YELLOW)
	
	apply_central_force(air_drag)
	
	camera_pivot.global_position = camera_pivot.global_position.lerp(global_position, delta * 20.0)
	if camera_tracking:
		look_at_point = look_at_point.lerp(global_position + (0.3*linear_velocity), delta * 5)
		var target_pivot_tranform = transform.looking_at(look_at_point)
		camera_pivot.transform = camera_pivot.transform.interpolate_with(target_pivot_tranform, delta * 5)
		camera.look_at(look_at_point)
	
	var right_stick = Input.get_vector("camera_left", "camera_right", "camera_up", "camera_down")
	camera_pivot.rotate(Vector3.DOWN, right_stick.x * delta * CAMERA_SPEED)
	camera_pivot.rotate_object_local(Vector3.RIGHT, right_stick.y * delta * CAMERA_SPEED)
	
	EventBus.spedometer_update.emit(linear_velocity.length())
	EventBus.altimeter_update.emit(global_position.y)
	
	if reset_flag: _reset()
		
	
func _reset():
	global_transform = Transform3D()
	linear_velocity = Vector3()
	angular_velocity = Vector3()
	reset_flag = false
