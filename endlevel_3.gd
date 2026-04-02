
extends Area2D


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		SpeedRunTimer.stop()
		var final_time = SpeedRunTimer.get_formatted_time()
		print("Final time: ", final_time)
		get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
