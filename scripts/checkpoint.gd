extends Area2D

@onready var sfx_checkpoint: AudioStreamPlayer = $sfx_checkpoint
@onready var checkpoint_sprite: AnimatedSprite2D = $"../AnimatedSprite2D"
@onready var light = $"../PointLight2D"

var activated := false

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	checkpoint_sprite.play("idle")

	light.enabled = false
	light.brightness_multiplier = 0.0

func _on_body_entered(body: Node2D) -> void:
	print("body entered: ", body.name)

	if body is CharacterBody2D:
		if body.last_checkpoint != $SpawnPoint.global_position:
			body.last_checkpoint = $SpawnPoint.global_position
			activate_checkpoint()
			print("Checkpoint activated")

func fade_in_light() -> void:
	light.enabled = true
	light.brightness_multiplier = 0.0

	var tween = create_tween()
	tween.tween_property(light, "brightness_multiplier", 1.0, 0.4)

func activate_checkpoint() -> void:
	if activated:
		return

	activated = true
	sfx_checkpoint.play()
	checkpoint_sprite.play("activate")
	fade_in_light()
