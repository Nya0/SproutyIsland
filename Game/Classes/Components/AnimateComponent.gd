class_name AnimateComponent
extends Node

@export var sprite_configs: Array[SpriteConfig]
@export var animated_sprite: AnimatedSprite3D


func play_animation(animation_name: String):
	animated_sprite.play(animation_name)

func animate_direction(direction: Vector3):
	var animation_name: String
	
	# Determine the primary direction of motion.
	var dir = direction.normalized()
	if dir == Vector3.ZERO:
		animation_name = "idle"
	elif dir.z < 0:
		animation_name = "walk_up"
	elif dir.z > 0:
		animation_name = "walk_down"
	
	if dir.x < 0:
		animation_name = "walk_left"
	elif dir.x > 0:
		animation_name = "walk_right"
   
	play_animation(animation_name)

func init_sprites():
	for config in sprite_configs:
		config.setup(animated_sprite)
