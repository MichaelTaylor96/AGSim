extends Label
class_name  Stopwatch

var time_elapsed := 0.

func _process(delta:float):
	time_elapsed += delta
	text = _format_time(time_elapsed)

func _format_time(seconds:float) -> String:
	var milliseconds := int((seconds - int(seconds)) * 1000)
	var secs := int(fmod(seconds, 60.))
	var mins := int(seconds / 60)
	return "%02d:%02d:%03d" % [mins, secs, milliseconds]
