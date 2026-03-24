
extends Area2D
@export var key_door: AnimatableBody2D

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		if body.has_key == true:
			key_door.open()
			body.has_key = false
