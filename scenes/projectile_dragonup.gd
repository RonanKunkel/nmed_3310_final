extends Area2D

@export var speed = 75
var direction = Vector2.UP
@onready var light = $PointLight2D

func _physics_process(delta):
	# Move the projectile in the assigned direction
	position += direction * speed * delta

# Connect the body_entered signal to handle collisions
func _on_body_entered(body: Node) -> void:
	if body.has_method("die"):
		light.enabled = false
		body.die()
		queue_free()
	else:
		light.enabled = false
		queue_free()
