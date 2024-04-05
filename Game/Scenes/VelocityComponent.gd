class_name VelocityComponent
extends Node

@export var maxSpeed: float = 15.8  # Ensure there is a default value.
@export var accelerationCoefficient: float = 8.4  # Ensure there is a default value.
@export var debugMode: bool = true

var velocity: Vector3 = Vector3.ZERO
var velocityOverride: Vector3 = Vector3.ZERO
var speedMultiplier: float = 1.0
var accelerationCoefficientMultiplier: float = 1.0

# These properties now have getters to ensure they are calculated dynamically.
func get_calculatedMaxSpeed() -> float:
	return maxSpeed * speedMultiplier

func get_accelerationCoefficient() -> float:
	return accelerationCoefficient * accelerationCoefficientMultiplier

func get_speedPercent() -> float:
	return min(velocity.length() / (get_calculatedMaxSpeed() if get_calculatedMaxSpeed() != 0 else 1), 1.0)

func _ready():
	if OS.is_debug_build() and debugMode:
		print_debug_information()

func print_debug_information() -> void:
	print("Max Speed: ", maxSpeed)
	print("Acceleration Coefficient: ", get_accelerationCoefficient())
	print("Current Velocity: ", velocity)

func accelerate_to_velocity(target_velocity: Vector3, delta: float) -> void:
	var acceleration_rate: float = 1.0 - exp(-get_accelerationCoefficient() * delta)
	velocity = velocity.lerp(target_velocity, acceleration_rate)
	print_debug_information()

func accelerate_in_direction(direction: Vector3, delta: float) -> void:
	accelerate_to_velocity(direction * get_calculatedMaxSpeed(), delta)

func get_max_velocity(direction: Vector3) -> Vector3:
	return direction * get_calculatedMaxSpeed()

func maximize_velocity(direction: Vector3) -> void:
	velocity = get_max_velocity(direction)

func decelerate(delta: float) -> void:
	accelerate_to_velocity(Vector3.ZERO, delta)

func move(characterBody: CharacterBody3D, delta: float) -> void:
	characterBody.velocity = velocityOverride if velocityOverride != Vector3.ZERO else velocity
	characterBody.move_and_slide()
