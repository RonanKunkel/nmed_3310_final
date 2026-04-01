extends CharacterBody2D

@export var follow_speed: float = 0.75  # Lower = slower, Higher = faster

func _process(delta):
	var mouse_pos = get_global_mouse_position()
	global_position = global_position.lerp(mouse_pos, follow_speed * delta)
