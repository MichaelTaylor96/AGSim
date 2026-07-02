extends Node

signal spedometer_update(speed:float)
signal altimeter_update(altitude:float)
signal thrust_update(thrust_val:float)
signal temp_update(temp_val:float)
signal boost_update(val:bool)

signal start_race(track_path:String, racer_path:String, mode:String)
signal resume()
signal restart()
signal main_menu()

signal garage_menu()
signal garage_chassis_select(chassis_id:int)
signal garage_repulsor_select(repulsor_id:int)
signal garage_thruster_select(thruster_id:int)
signal garage_aux_select(aux_id:int)
signal garage_save_build(build_name:String)
