extends Node

var time_elapsed: float = 0.0
var timer_running: bool = false
var timed_mode: bool = false  # set this before starting a run

func start() -> void:
	if timed_mode:
		timer_running = true

func stop() -> void:
	timer_running = false

func reset() -> void:
	time_elapsed = 0.0
	timer_running = false

func _process(delta: float) -> void:
	if timer_running and timed_mode:
		time_elapsed += delta

func get_formatted_time() -> String:
	if not timed_mode:
		return ""
	var minutes := int(time_elapsed / 60)
	var seconds := int(fmod(time_elapsed, 60))
	var msec := int(fmod(time_elapsed, 1) * 100)
	return "%02d:%02d:%02d" % [minutes, seconds, msec]
