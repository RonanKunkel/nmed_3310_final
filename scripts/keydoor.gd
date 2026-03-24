extends AnimatableBody2D

var is_open = false

func open():
	if is_open == false:
		is_open = true
		$AnimationPlayer.play("KeyDoor")
