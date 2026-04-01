extends Area2D

# This function is connected to the "body_entered" signal
func _on_body_entered(body: Node2D):
	print("body entered: ", body.name)
	if body is CharacterBody2D:
		# Update the player's last checkpoint
		body.last_checkpoint = $SpawnPoint.global_position
		print("Checkpoint activated")
