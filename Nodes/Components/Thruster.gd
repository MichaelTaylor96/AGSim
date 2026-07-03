extends Component
class_name Thruster

@export var max_thrust : float
@export var boost_modifier : float
@export var boost_heat_rate : float = 500
@export var cooling_rate : float = 200
@export var max_temp : float = 2500
@export var boost_flame : Node3D
@export var thrust_flame : GPUParticles3D

var boosting = false
var temp : float
var thrust := 0.0
	
	
func _process(delta: float) -> void:
	var boost := boost_modifier if Input.is_action_pressed("boost") else 0.0
	if boost > 0 and not boosting:
		boosting = true
		EventBus.boost_update.emit(true)
	elif boost == 0 and boosting:
		boosting = false
		EventBus.boost_update.emit(false)
	var thrust_val := Input.get_action_strength("thrust")
	
	if boosting and temp < max_temp: temp += boost_heat_rate * delta
	else: temp -= cooling_rate * delta
	thrust = (max_thrust * thrust_val) + boost
	boost_flame.visible = boost > 0
	thrust_flame.emitting = thrust_val > 0
	
	EventBus.temp_update.emit(temp/max_temp)
	EventBus.thrust_update.emit(thrust_val)
