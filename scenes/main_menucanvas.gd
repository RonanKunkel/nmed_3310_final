extends CanvasLayer

@onready var main_buttons = $VBoxContainer
@onready var level_selector = $LevelSelector
@onready var credits = $Credits
@onready var timer = $timer

@onready var play_button = $VBoxContainer/PlayButton
@onready var tutorial_button = $VBoxContainer/TutorialButton
@onready var level_selector_button = $VBoxContainer/LevelSelectorButton
@onready var credits_button = $VBoxContainer/CreditsButton
@onready var quit_button = $VBoxContainer/QuitButton

@onready var timed_button = $timer/VBoxContainer3/timed
@onready var untimed_button = $timer/VBoxContainer3/untimed
@onready var timer_back_button = $timer/VBoxContainer3/BackButton

@onready var level1_button = $LevelSelector/VBoxContainer/Level1
@onready var level2_button = $LevelSelector/VBoxContainer/Level2
@onready var level3_button = $LevelSelector/VBoxContainer/Level3
@onready var level_back_button = $LevelSelector/VBoxContainer/BackButton

@onready var credits_back_button = $Credits/BackButton

var using_controller := false

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	level_selector.hide()
	credits.hide()
	timer.hide()

	play_button.pressed.connect(_on_play_pressed)
	timed_button.pressed.connect(_on_yes_pressed)
	untimed_button.pressed.connect(_on_no_pressed)
	tutorial_button.pressed.connect(_on_tutorial_pressed)
	level_selector_button.pressed.connect(_on_level_selector_pressed)
	quit_button.pressed.connect(_on_quit_pressed)
	credits_button.pressed.connect(_on_credits_pressed)
	level1_button.pressed.connect(_on_level1_pressed)
	level2_button.pressed.connect(_on_level2_pressed)
	level3_button.pressed.connect(_on_level3_pressed)
	level_back_button.pressed.connect(_on_back_pressed)
	timer_back_button.pressed.connect(_on_back_pressed)
	credits_back_button.pressed.connect(_on_back_pressed)

	_setup_focus()
	play_button.grab_focus()

func _input(event):
	if event is InputEventJoypadButton or event is InputEventJoypadMotion:
		if not using_controller:
			using_controller = true
			Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

	elif event is InputEventMouseMotion or event is InputEventMouseButton:
		if using_controller:
			using_controller = false
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _setup_focus():
	play_button.focus_neighbor_bottom = tutorial_button.get_path()
	tutorial_button.focus_neighbor_top = play_button.get_path()
	tutorial_button.focus_neighbor_bottom = level_selector_button.get_path()
	level_selector_button.focus_neighbor_top = tutorial_button.get_path()
	level_selector_button.focus_neighbor_bottom = credits_button.get_path()
	credits_button.focus_neighbor_top = level_selector_button.get_path()
	credits_button.focus_neighbor_bottom = quit_button.get_path()
	quit_button.focus_neighbor_top = credits_button.get_path()

	timed_button.focus_neighbor_bottom = untimed_button.get_path()
	untimed_button.focus_neighbor_top = timed_button.get_path()
	untimed_button.focus_neighbor_bottom = timer_back_button.get_path()
	timer_back_button.focus_neighbor_top = untimed_button.get_path()

	level1_button.focus_neighbor_bottom = level2_button.get_path()
	level2_button.focus_neighbor_top = level1_button.get_path()
	level2_button.focus_neighbor_bottom = level3_button.get_path()
	level3_button.focus_neighbor_top = level2_button.get_path()
	level3_button.focus_neighbor_bottom = level_back_button.get_path()
	level_back_button.focus_neighbor_top = level3_button.get_path()

func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		if timer.visible or level_selector.visible or credits.visible:
			_on_back_pressed()

func _on_play_pressed():
	main_buttons.hide()
	timer.show()
	timed_button.grab_focus()

func _on_tutorial_pressed():
	get_tree().change_scene_to_file("res://scenes/tutorial.tscn")

func _on_level_selector_pressed():
	main_buttons.hide()
	level_selector.show()
	level1_button.grab_focus()

func _on_credits_pressed():
	main_buttons.hide()
	credits.show()
	credits_back_button.grab_focus()

func _on_yes_pressed():
	SpeedRunTimer.timed_mode = true
	SpeedRunTimer.reset()
	SpeedRunTimer.start()
	get_tree().change_scene_to_file("res://scenes/LVL1.tscn")

func _on_no_pressed():
	SpeedRunTimer.timed_mode = false
	SpeedRunTimer.reset()
	get_tree().change_scene_to_file("res://scenes/LVL1.tscn")

func _on_level1_pressed():
	get_tree().change_scene_to_file("res://scenes/LVL1.tscn")

func _on_level2_pressed():
	get_tree().change_scene_to_file("res://scenes/LVL2.tscn")

func _on_level3_pressed():
	get_tree().change_scene_to_file("res://scenes/lvl_3.tscn")

func _on_back_pressed():
	level_selector.hide()
	credits.hide()
	timer.hide()
	main_buttons.show()
	play_button.grab_focus()

func _on_quit_pressed():
	get_tree().quit()
