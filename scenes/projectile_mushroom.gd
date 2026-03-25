extends Area2D
@export var speed = 75
var direction = Vector2.LEFT
@onready var timer = $Timer
func _physics_process(delta):
	# Move the projectile in the assigned direction
	position += direction * speed * delta

# Connect the body_entered signal to handle collisions
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		get_tree().reload_current_scene()
	else:
		queue_free()
