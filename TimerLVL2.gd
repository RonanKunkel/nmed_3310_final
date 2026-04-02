extends Label


func _process(_delta: float) -> void:
	text = SpeedRunTimer.get_formatted_time()
