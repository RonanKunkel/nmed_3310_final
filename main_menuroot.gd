extends Node2D

@onready var time_label: Label = $CanvasLayer/VBoxContainer/runtime

func _ready():
	if SpeedRunTimer.timed_mode and SpeedRunTimer.time_elapsed > 0:
		time_label.text = "Last Run: " + SpeedRunTimer.get_formatted_time()
	else:
		time_label.text = ""
