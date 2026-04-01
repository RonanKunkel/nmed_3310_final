extends AnimatableBody2D

@export var linked_lever: Area2D
@onready var sfx_door: AudioStreamPlayer = $sfx_door

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
	if !state:
		close()

func open():
	if is_open == false:
		is_open = true
		sfx_door.pitch_scale = 0.7
		sfx_door.play()
		$AnimationPlayer.play("KeyDoor")
		
func close():
	if is_open:
		is_open = false
		sfx_door.pitch_scale = 0.7
		sfx_door.play()
		$AnimationPlayer.play_backwards("KeyDoor")
		
