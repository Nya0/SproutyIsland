extends Resource
class_name SpriteConfig

@export var animations: Array[String]

@export var spritesheet: Texture2D
@export var frames: int

func setup(animated_sprite: AnimatedSprite3D) -> void:
	
	var source_image = spritesheet.get_image()
	var sprite_frames = animated_sprite.sprite_frames
	
	var frame_height = source_image.get_height() / animations.size() 
	var frame_width = source_image.get_width() / frames #
	
	for index in range(animations.size()):
		var animation_name = animations[index]
		
		sprite_frames.add_animation(animation_name)

		for frame in range(frames):
		
			var frame_data := Image.create(int(frame_width), int(frame_height), false, Image.FORMAT_RGBA8)
			var src_rect = Rect2(frame * frame_width, index * frame_height, frame_width, frame_height)

			print(src_rect)
			frame_data.blit_rect(source_image, src_rect, Vector2.ZERO)
			
			var final_frame := ImageTexture.create_from_image(frame_data)
			sprite_frames.add_frame(animation_name, final_frame)

