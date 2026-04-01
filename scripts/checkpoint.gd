extends Area2D

@onready var sfx_checkpoint: AudioStreamPlayer = $sfx_checkpoint


# This function is connected to the "body_entered" signal
func _on_body_entered(body: Node2D):
	print("body entered: ", body.name)
	if body is CharacterBody2D:
		# Update the player's last checkpoint
		if body.last_checkpoint != $SpawnPoint.global_position:
			sfx_checkpoint.play()
			
		body.last_checkpoint = $SpawnPoint.global_position
		print("Checkpoint activated")
