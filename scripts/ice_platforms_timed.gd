extends StaticBody2D

@export var visible_duration: float = 3.0
@export var hidden_duration: float = 2.0
@export var fade_duration: float = 0.5
# If set, the platform will only activate when this lever is toggled on
@export var linked_lever: Area2D

@onready var timer: Timer = $Timer
@onready var collision: CollisionShape2D = $CollisionShape2D

enum State { VISIBLE, FADING, HIDDEN }
var state: State = State.VISIBLE
var fade_elapsed: float = 0.0
var lever_controlled: bool = false

func _ready() -> void:
	timer.one_shot = true
	timer.timeout.connect(_on_timer_timeout)
	
	if linked_lever:
		lever_controlled = true
		linked_lever.lever_toggled.connect(_on_lever_toggled)
		# Start dormant until the lever is pulled
		process_mode = Node.PROCESS_MODE_DISABLED
		visible = false
		collision.disabled = true
	else:
		_enter_visible()

func _process(delta: float) -> void:
	if state == State.FADING:
		fade_elapsed += delta
		var t = clamp(fade_elapsed / fade_duration, 0.0, 1.0)
		modulate.a = lerp(1.0, 0.0, t)
		if t >= 1.0:
			_enter_hidden()

func _on_lever_toggled(lever_state: bool) -> void:
	if lever_state:
		process_mode = Node.PROCESS_MODE_INHERIT
		visible = true
		_enter_visible()
	else:
		# Immediately kill the cycle and hide
		timer.stop()
		process_mode = Node.PROCESS_MODE_DISABLED
		visible = false
		collision.disabled = true
		modulate.a = 1.0
		state = State.VISIBLE  # Reset so it starts fresh next time lever is on

func _enter_visible() -> void:
	state = State.VISIBLE
	modulate.a = 1.0
	collision.disabled = false
	timer.wait_time = visible_duration
	timer.start()

func _enter_fading() -> void:
	state = State.FADING
	fade_elapsed = 0.0
	await get_tree().create_timer(fade_duration * 0.5).timeout
	if state == State.FADING:
		collision.disabled = true

func _enter_hidden() -> void:
	state = State.HIDDEN
	modulate.a = 0.0
	collision.disabled = true
	timer.wait_time = hidden_duration
	timer.start()

func _on_timer_timeout() -> void:
	match state:
		State.VISIBLE:
			_enter_fading()
		State.HIDDEN:
			_enter_visible()
