extends StaticBody2D

# How long the platform stays visible before disappearing
@export var visible_duration: float = 3.0
# How long the platform stays hidden before reappearing
@export var hidden_duration: float = 2.0
# How long the fade-out animation takes
@export var fade_duration: float = 0.5

@onready var timer: Timer = $Timer
@onready var collision: CollisionShape2D = $CollisionShape2D

enum State { VISIBLE, FADING, HIDDEN }
var state: State = State.VISIBLE
var fade_elapsed: float = 0.0

func _ready() -> void:
	timer.one_shot = true
	timer.timeout.connect(_on_timer_timeout)
	_enter_visible()

func _process(delta: float) -> void:
	if state == State.FADING:
		fade_elapsed += delta
		var t = clamp(fade_elapsed / fade_duration, 0.0, 1.0)
		modulate.a = lerp(1.0, 0.0, t)
		if t >= 1.0:
			_enter_hidden()

func _enter_visible() -> void:
	state = State.VISIBLE
	modulate.a = 1.0
	collision.disabled = false
	timer.wait_time = visible_duration
	timer.start()

func _enter_fading() -> void:
	state = State.FADING
	fade_elapsed = 0.0
	# Disable collision partway through the fade so the player drops naturally
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
