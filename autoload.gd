extends Node

var time_elapsed: float = 0.0
var timer_running: bool = false

func start() -> void:
	timer_running = true

func stop() -> void:
	timer_running = false

func reset() -> void:
	time_elapsed = 0.0
	timer_running = false

func _process(delta: float) -> void:
	if timer_running:
		time_elapsed += delta

func get_formatted_time() -> String:
	var minutes := int(time_elapsed / 60)
	var seconds := int(fmod(time_elapsed, 60))
	var msec := int(fmod(time_elapsed, 1) * 100)
	return "%02d:%02d:%02d" % [minutes, seconds, msec]
