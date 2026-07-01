extends Component
class_name Thruster

@export var max_thrust : float
@export var boost_modifier : float
@export var boost_heat_rate : float
@export var boost_flame : Node3D
@export var thrust_flame : GPUParticles3D

var temp : float
var thrust := 0.0
	
	
func _process(delta: float) -> void:
	var boost := boost_modifier if Input.is_action_pressed("boost") else 0.0
	var thrust_val := Input.get_action_strength("thrust")
	thrust = (max_thrust * thrust_val) + boost
	boost_flame.visible = boost > 0
	thrust_flame.emitting = thrust_val > 0
	
	EventBus.thrust_update.emit(thrust_val)
