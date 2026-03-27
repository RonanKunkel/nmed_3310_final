extends Area2D

# Connect the body_entered signal to handle collisions
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.die()
