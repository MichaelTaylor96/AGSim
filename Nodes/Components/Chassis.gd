extends Component
class_name Chassis

@export var cross_area := 2.5
@export var drag_coefficient := 0.4
@export var yaw_speed := 3.0
@export var pitch_speed := 2.0
@export var roll_speed := 2.0
@export var air_brake := 50

var drag_modifier := 0.0
var roll := 0.0
var pitch := 0.0
var yaw := 0.0


func _process(delta: float) -> void:
	var air_brake_val = Input.get_action_strength("air_brake")
	drag_modifier = drag_coefficient * cross_area * (1.225/2) * air_brake * air_brake_val
		
	yaw = Input.get_axis("steer_right", "steer_left") * yaw_speed
	pitch = Input.get_axis("pitch_down", "pitch_up") * pitch_speed
	roll = Input.get_axis("roll_right", "roll_left") * roll_speed
