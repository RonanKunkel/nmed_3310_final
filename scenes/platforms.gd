extends CharacterBody2D

@export var linked_lever: Area2D

func _ready():
	process_mode = Node.PROCESS_MODE_DISABLED  # disable
	visible = false
	if linked_lever:
		linked_lever.lever_toggled.connect(_on_lever_toggled)

func _on_lever_toggled(state: bool) -> void:
	if state:
		process_mode = Node.PROCESS_MODE_INHERIT  # enable
		visible = true
	else:
		process_mode = Node.PROCESS_MODE_DISABLED  # disable
		visible = false
