extends CharacterBody2D

@onready var anim = $AnimatedSprite2D
@onready var camera = $Camera2D
@onready var candle = $PointLight2D

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
var is_dead = false


func _ready() -> void:
	start_position = global_position
	candle_start_pos = candle.position
	camera_start_offset = camera.offset

func _physics_process(delta: float) -> void:
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
		velocity.x = move_toward(velocity.x, 0, FRICTION * delta)

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
	if velocity.x < 0:
		anim.flip_h = true
	elif velocity.x > 0:
		anim.flip_h = false

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body == self:
		global_position = Vector2(0, -128)
		velocity = Vector2.ZERO
		
		
func die() :
	if is_dead : return
	is_dead = true
	velocity = Vector2.ZERO
	
	
