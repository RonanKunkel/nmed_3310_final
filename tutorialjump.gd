extends Sprite2D

@export var linked_lever: Area2D

func _ready():
	visible = false
	if linked_lever:
		linked_lever.lever_toggled.connect(_on_lever_toggled)

func _on_lever_toggled(state: bool) -> void:
	if state:
		visible = true
		if has_node("AnimationPlayer"):
			$AnimationPlayer.play("jump")
	else:
		visible = false
		if has_node("AnimationPlayer"):
			$AnimationPlayer.stop()
