extends Node2D
class_name  DEBUG_DRAWER


var kanim_sprite : KANIMSprite
var animated_sprite : AnimatedSprite2D
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _draw():
	var current_animation : String = animated_sprite.animation
	var line_size = -1
	var local_colour = kanim_sprite.colour
	local_colour.a = 0.25
	#line_size += (2 - kanim_rendercam.zoom.x)*2 #scale to the camera
	if kanim_sprite.build_holder.draw_debug:
		if animated_sprite.visible and animated_sprite.sprite_frames:
			var sprite_texture : Texture = animated_sprite.sprite_frames.get_frame_texture(current_animation,kanim_sprite.frame)
			var size = sprite_texture.get_size()*0.5
			#draw_line(kanim_sprite.offset + Vector2(size.x, size.y), kanim_sprite.offset + Vector2(-size.x, size.y), local_colour, line_size)
			#draw_line(kanim_sprite.offset + Vector2(-size.x, size.y), kanim_sprite.offset + Vector2(-size.x, -size.y), local_colour, line_size)
			#draw_line(kanim_sprite.offset + Vector2(-size.x, -size.y), kanim_sprite.offset + Vector2(size.x, -size.y), local_colour, line_size)
			#draw_line(kanim_sprite.offset + Vector2(size.x, -size.y), kanim_sprite.offset + Vector2(size.x, size.y), local_colour, line_size)
			
			draw_circle(Vector2.ZERO,1,kanim_sprite.colour,true,-1,false)
			draw_circle(Vector2.ZERO,1,Color.BLACK,false,-1,false)
			#draw_circle(Vector2.ZERO,2,kanim_sprite.colour,false,1,false)


func _process(delta):
	queue_redraw()
	z_index = 100
