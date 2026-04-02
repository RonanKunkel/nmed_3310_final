extends Label

func _ready() -> void:
	SpeedRunTimer.start()  # Remove this if you start the timer elsewhere

func _process(_delta: float) -> void:
	text = SpeedRunTimer.get_formatted_time()
