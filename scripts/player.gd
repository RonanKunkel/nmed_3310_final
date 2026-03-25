extends CharacterBody2D

@onready var anim = $AnimatedSprite2D
@onready var camera = $Camera2D
@onready var candle = $PointLight2D
@onready var death_timer = $DeathTimer
@onready var collision = $CollisionShape2D
@onready var dev_label = $"../DevMenu/DevLabel"

var has_key: bool = false
var is_dead = false

# DEV MODE
var dev_mode_enabled := false
var invulnerable := false
var flight_mode := false
var noclip := false

const SPEED = 105.0
const JUMP_VELOCITY = -291.75
const ACCELERATION = 450.0
const FRICTION = 600.0
const MIN_JUMP_CUT = -75.0

const LIGHT_SHIFT = 10.0
const LIGHT_SPEED = 8.0
const CAMERA_SHIFT = 20.0
const CAMERA_SPEED = 4.0

var start_position: Vector2
var candle_start_pos: Vector2
var camera_start_offset: Vector2

var light_y := 0.0
var target_light_y := 0.0
var target_camera_y := 0.0


func _ready() -> void:
	start_position = global_position
	candle_start_pos = candle.position
	camera_start_offset = camera.offset
	
	if dev_label:
		dev_label.visible = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("dev_mode"):
		set_dev_mode_enabled(!dev_mode_enabled)

	elif event.is_action_pressed("dev_invulnerable"):
		if dev_mode_enabled:
			set_invulnerable(!invulnerable)

	elif event.is_action_pressed("dev_flight"):
		if dev_mode_enabled:
			set_flight_mode(!flight_mode)

	elif event.is_action_pressed("dev_noclip"):
		if dev_mode_enabled:
			set_noclip(!noclip)

func set_dev_mode_enabled(value: bool) -> void:
	dev_mode_enabled = value
	
	if not dev_mode_enabled:
		invulnerable = false
		flight_mode = false
		noclip = false
		collision.disabled = false
		velocity = Vector2.ZERO
	
	update_dev_label()


func set_invulnerable(value: bool) -> void:
	if not dev_mode_enabled:
		return
	invulnerable = value
	update_dev_label()


func set_flight_mode(value: bool) -> void:
	if not dev_mode_enabled:
		return
	
	flight_mode = value
	
	if flight_mode:
		noclip = false
		collision.disabled = false
		velocity = Vector2.ZERO
	
	update_dev_label()


func set_noclip(value: bool) -> void:
	if not dev_mode_enabled:
		return
	
	noclip = value
	
	if noclip:
		flight_mode = false
		collision.disabled = true
		velocity = Vector2.ZERO
	else:
		collision.disabled = false
	
	update_dev_label()


func _physics_process(delta: float) -> void:
	if is_dead:
		if not is_on_floor():
			velocity += get_gravity() * delta
		move_and_slide()
		return
	
	if noclip:
		handle_noclip(delta)
		return
		
	if flight_mode:
		handle_flight(delta)
		return
	
	# Gravity
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	# Jump
	if Input.is_action_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	if Input.is_action_just_released("jump"):
		if velocity.y < MIN_JUMP_CUT:
			velocity.y = MIN_JUMP_CUT

	# Horizontal movement
	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = move_toward(velocity.x, direction * SPEED, ACCELERATION * delta)
	else:
		velocity.x = move_toward(velocity.x, 0.0, FRICTION * delta)

	move_and_slide()

	# Check if player is standing still on the floor
	var standing_still: bool = is_on_floor() and abs(velocity.x) < 0.1 and abs(velocity.y) < 0.1
	# Only allow look up/down while standing still
	if standing_still:
		if Input.is_action_pressed("look_up"):
			target_light_y = -LIGHT_SHIFT
			target_camera_y = -CAMERA_SHIFT
		elif Input.is_action_pressed("look_down"):
			target_light_y = LIGHT_SHIFT
			target_camera_y = CAMERA_SHIFT
		else:
			target_light_y = 0.0
			target_camera_y = 0.0
	else:
		target_light_y = 0.0
		target_camera_y = 0.0

	# Smooth light movement
	light_y = lerp(light_y, target_light_y, LIGHT_SPEED * delta)
	candle.position.y = candle_start_pos.y + light_y

	# Smooth camera lag
	camera.offset.y = lerp(camera.offset.y, camera_start_offset.y + target_camera_y, CAMERA_SPEED * delta)

	# Animation
	if standing_still:
		anim.play("Idle")
	else:
		anim.play("Walk")

	# Flip sprite
	if velocity.x < 0.0:
		anim.flip_h = true
	elif velocity.x > 0.0:
		anim.flip_h = false


func handle_flight(_delta: float) -> void:
	var move_input := Vector2(
		Input.get_axis("move_left", "move_right"),
		Input.get_axis("move_up", "move_down")
	)

	if move_input.length() > 1.0:
		move_input = move_input.normalized()

	velocity = move_input * SPEED
	move_and_slide()

	if move_input.x < 0.0:
		anim.flip_h = true
	elif move_input.x > 0.0:
		anim.flip_h = false

	if move_input == Vector2.ZERO:
		anim.play("Idle")
	else:
		anim.play("Walk")


func handle_noclip(delta: float) -> void:
	var move_input := Vector2(
		Input.get_axis("move_left", "move_right"),
		Input.get_axis("move_up", "move_down")
	)

	if move_input.length() > 1.0:
		move_input = move_input.normalized()

	global_position += move_input * SPEED * delta

	if move_input.x < 0.0:
		anim.flip_h = true
	elif move_input.x > 0.0:
		anim.flip_h = false

	if move_input == Vector2.ZERO:
		anim.play("Idle")
	else:
		anim.play("Walk")

func update_dev_label() -> void:
	if not dev_mode_enabled:
		dev_label.visible = false
		return

	dev_label.visible = true
	dev_label.text = "DEV: ON\n"
	dev_label.text += "Invulnerable: " + on_off(invulnerable) + "\n"
	dev_label.text += "Flight: " + on_off(flight_mode) + "\n"
	dev_label.text += "Noclip: " + on_off(noclip)

func on_off(value: bool) -> String:
	if value:
		return "ON"
	return "OFF"

func die() -> void:
	if invulnerable:
		return
	if is_dead:
		return

	is_dead = true
	velocity.x = 0.0
	anim.play("Death")
	death_timer.start()


func _on_death_timer_timeout() -> void:
	get_tree().reload_current_scene()
