extends CanvasLayer

@onready var main_buttons = $VBoxContainer
@onready var level_selector = $LevelSelector

func _ready():
	level_selector.hide()

	$VBoxContainer/PlayButton.pressed.connect(_on_play_pressed)
	$VBoxContainer/LevelSelectorButton.pressed.connect(_on_level_selector_pressed)
	$VBoxContainer/QuitButton.pressed.connect(_on_quit_pressed)

	$LevelSelector/VBoxContainer/Level1.pressed.connect(_on_level1_pressed)
	$LevelSelector/VBoxContainer/Level2.pressed.connect(_on_level2_pressed)
	$LevelSelector/VBoxContainer/Level3.pressed.connect(_on_level3_pressed)
	$LevelSelector/VBoxContainer/BackButton.pressed.connect(_on_back_pressed)

func _on_play_pressed():
	get_tree().change_scene_to_file("res://scenes/LVL1.tscn")


func _on_level_selector_pressed():
	main_buttons.hide()
	level_selector.show()

func _on_level1_pressed():
	get_tree().change_scene_to_file("res://scenes/LVL1.tscn")

func _on_level2_pressed():
	get_tree().change_scene_to_file("res://scenes/LVL2.tscn")

func _on_level3_pressed():
	get_tree().change_scene_to_file("res://scenes/lvl_3.tscn")

func _on_back_pressed():
	level_selector.hide()
	main_buttons.show()

func _on_quit_pressed():
	get_tree().quit()
