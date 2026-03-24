extends AnimatableBody2D

@export var linked_lever: Area2D

var is_open = false

func _ready():
	$doorarea.body_entered.connect(_on_body_entered)
	if linked_lever:
		linked_lever.lever_toggled.connect(_on_lever_toggled)

func _on_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		if body.has_key == true:
			open()
			body.has_key = false

func _on_lever_toggled(state: bool) -> void:
	if state:
		open()

func open():
	if is_open == false:
		is_open = true
		$AnimationPlayer.play("KeyDoor")
