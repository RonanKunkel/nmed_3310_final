extends Area2D

@onready var sfx_crown: AudioStreamPlayer = $sfx_crown



func _ready():
	body_entered.connect(_on_body_entered)
	$AnimationPlayer.animation_finished.connect(_on_collect_done)

func _on_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		body.has_key = true
		
		if body.has_method("equip_crown"):
			body.equip_crown()
		
		sfx_crown.play()
		$AnimationPlayer.play("collect")

func _on_collect_done(anim_name):
	if anim_name == "collect":
		queue_free()
