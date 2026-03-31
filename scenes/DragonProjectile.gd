extends CharacterBody2D

@onready var ShootTimer = $Timer
# Preload the bullet scene
var projectile_scene = preload("res://scenes/projectile_dragon.tscn")
func _ready():
	ShootTimer.start()

func _on_timer_timeout() -> void:
	shoot(get_tree().get_first_node_in_group("player").global_position)
	
func shoot(_target_position: Vector2):
	# 1. Instantiate the bullet
	var projectile_dragon = projectile_scene.instantiate()
	
	# 2. Position it at the Muzzle
	projectile_dragon.global_position = $Muzzle.global_position
	
	# 3. Calculate direction towards target (e.g., the player)
	#var dir = (target_position - $Muzzle.global_position).normalized()
	#projectile.direction = dir
	
	# 4. Add the bullet to the main scene, NOT as a child of the mob
	get_tree().root.add_child(projectile_dragon)
	
