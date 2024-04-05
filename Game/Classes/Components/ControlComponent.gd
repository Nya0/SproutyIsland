class_name ControlComponent
extends Node

@export var velocityComponent: VelocityComponent
@export var animateComponent: AnimateComponent

var input_map = {
	"forward": "move_forward",
	"backward": "move_back",
	"left": "move_left",
	"right": "move_right"
}

func _ready():
	animateComponent.init_sprites()

func get_input_direction() -> Vector3:

	var direction: Vector3 = Vector3(
		Input.get_action_strength(input_map.right) - Input.get_action_strength(input_map.left),
		0,  # This is a ground movement component, so no Y-axis movement.
		Input.get_action_strength(input_map.backward) - Input.get_action_strength(input_map.forward)
	)
	return direction.normalized()  # Normalize the direction.

func handle_input(characterBody: CharacterBody3D, delta: float) -> void:
	var input_direction: Vector3 = get_input_direction()
	
	animateComponent.animate_direction(input_direction)
	
	if Input.is_action_pressed("sprint"):
		velocityComponent.maxSpeed = 30
		velocityComponent.maximize_velocity(input_direction)
	
	velocityComponent.accelerate_in_direction(input_direction, delta)
	velocityComponent.move(characterBody, delta)
