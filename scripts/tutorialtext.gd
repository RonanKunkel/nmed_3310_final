extends CanvasLayer

@export var levers: Array[Area2D] = []

func _ready():
	_hide_all()
	for lever in levers:
		if lever:
			lever.lever_toggled.connect(_on_lever_toggled.bind(lever))

func _hide_all():
	for child in get_children():
		child.visible = false

func _on_lever_toggled(state: bool, lever: Area2D) -> void:
	_hide_all()
	if state:
		var index = levers.find(lever)
		var children = get_children()
		if index >= 0 and index < children.size():
			children[index].visible = true
