extends Area2D

var opened := false

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D and not opened:
		opened = true
		$AnimationPlayer.play("CloseGate")
