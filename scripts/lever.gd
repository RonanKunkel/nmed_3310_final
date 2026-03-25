extends Area2D

var playerInRange = false;
var leverActivated = false;

signal lever_toggled(state)

@onready var anim = $AnimationPlayer

func _ready() -> void:
	connect("body_entered", _on_body_entered)
	connect("body_exited", _on_body_exited)

func _process(_delta: float) -> void:
	if playerInRange and Input.is_action_just_pressed("interact"):
		toggle_lever()
		
func toggle_lever() -> void:
	leverActivated = !leverActivated
	
	if leverActivated:
		anim.play("Toggle")
	else:
		anim.play_backwards("Toggle")
	
	emit_signal("lever_toggled", leverActivated)
	
func _on_body_entered(body: Node2D) -> void:
	if body.name == "player":
		playerInRange = true
		
func _on_body_exited(body: Node2D) -> void:
	if body.name == "player":
		playerInRange = false
	
