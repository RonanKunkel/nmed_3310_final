extends AnimatableBody2D

@export var linked_lever: Area2D

var is_open = false
var is_unlocked = false

func _ready():
	$doorarea.body_entered.connect(_on_body_entered)
	if linked_lever:
		linked_lever.lever_toggled.connect(_on_lever_toggled)

func _on_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		if body.has_key == true and !is_unlocked:
			body.has_key = false
			unlock_and_open()

func _on_lever_toggled(state: bool) -> void:
	if state:
		open()
	if !state:
		close()

func unlock_and_open():
	is_unlocked = true
	is_open = true
	$AnimationPlayer.play("Door Unlocked")
	await $AnimationPlayer.animation_finished
	$AnimationPlayer2.play("KeyDoor")

func open():
	if is_open == false:
		is_open = true
		$AnimationPlayer2.play("KeyDoor")
		
func close():
	if is_open:
		is_open = false
		$AnimationPlayer2.play_backwards("KeyDoor")
		
