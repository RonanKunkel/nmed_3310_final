extends CharacterBody2D

@onready var ShootTimer = $Timer
@onready var sfx_dragon: AudioStreamPlayer2D = $sfx_dragon
# Preload the bullet scene
var projectile_scene = preload("res://scenes/projectile_dragon_ice.tscn")
func _ready():
	ShootTimer.start()

func _on_timer_timeout() -> void:
	shoot(get_tree().get_first_node_in_group("player").global_position)
	
func shoot(_target_position: Vector2):
	# 1. Instantiate the bullet
	var projectile_dragon_ice = projectile_scene.instantiate()
	
	# 2. Position it at the Muzzle
	projectile_dragon_ice.global_position = $Muzzle.global_position
	
	# 3. Calculate direction towards target (e.g., the player)
	#var dir = (target_position - $Muzzle.global_position).normalized()
	#projectile.direction = dir
	
	sfx_dragon.play()
	
	# 4. Add the bullet to the main scene, NOT as a child of the mob
	get_tree().root.add_child(projectile_dragon_ice)
	
