extends CharacterBody2D


const SPEED = 105.0
const JUMP_VELOCITY = -275.0
var start_position: Vector2  # Stores the spawn point
const ACCELERATION = 450.0
const FRICTION = 600.0
const MIN_JUMP_CUT = -75.0

func _ready() -> void:
	start_position = global_position  # Save starting position on launch

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	if Input.is_action_just_released("ui_accept"):
		if velocity.y  < MIN_JUMP_CUT:
			velocity.y = MIN_JUMP_CUT 
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = move_toward(velocity.x,direction * SPEED,ACCELERATION * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, FRICTION * delta)

	move_and_slide()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body == self:
		global_position = Vector2(0,-128)  # Teleport back to start
		velocity = Vector2.ZERO           # Stop all momentum
