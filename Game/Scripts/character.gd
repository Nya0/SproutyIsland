extends CharacterBody3D

@export var gravity: float = 9.8
@export var jump_force: float = 20.0

@export var sprite_configs: Array[SpriteConfig]

enum States {
	WALKING,
	SPRINTING,
	FALLING
}

var current_state = States.WALKING

# Movement variables
var walk_speed: float = 10.0
var sprint_speed: float = 20.0
var acceleration: float = 10.0
var deceleration: float = 12.0

func _ready():
	setup_sprites()

func _physics_process(delta: float) -> void:
	var input_vector: Vector3 = Vector3.ZERO
	input_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input_vector.z = Input.get_action_strength("move_back") - Input.get_action_strength("move_forward")
	input_vector = input_vector.normalized()
	
	# Apply gravity always
	velocity.y -= gravity * delta
	
	# Check for falling
	if not is_on_floor() and velocity.y < 0:
		current_state = States.FALLING
	
	# Handle jump input
	if is_on_floor() and Input.is_action_just_pressed("ui_accept"):
		velocity.y = jump_force
		# Optionally, set to WALKING or SPRINTING based on speed
	
	match current_state:
		States.WALKING:
			handle_walking_state(input_vector, delta)
		States.SPRINTING:
			handle_sprinting_state(input_vector, delta)
		States.FALLING:
			handle_falling_state(delta)
	
	# Move the character
	move_and_slide()

func setup_sprites():
	for config in sprite_configs:
		config.setup($AnimatedSprite)

func handle_walking_state(input_vector: Vector3, delta: float):
	if Input.is_action_pressed("sprint"):
		current_state = States.SPRINTING
	apply_movement(input_vector, walk_speed, delta)

func handle_sprinting_state(input_vector: Vector3, delta: float):
	if not Input.is_action_pressed("sprint"):
		current_state = States.WALKING
	apply_movement(input_vector, sprint_speed, delta)

func handle_falling_state(delta: float):
	if is_on_floor():
		current_state = States.WALKING  # or SPRINTING based on input

func apply_movement(input_vector: Vector3, speed: float, delta: float):
	if input_vector != Vector3.ZERO:
		velocity.x = lerp(velocity.x, input_vector.x * speed, acceleration * delta)
		velocity.z = lerp(velocity.z, input_vector.z * speed, acceleration * delta)
	else:
		velocity.x = lerp(velocity.x, 0.0, acceleration * delta)
		velocity.z = lerp(velocity.z, 0.0, acceleration * delta)
