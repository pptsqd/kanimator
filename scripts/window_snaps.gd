@tool
extends Window

@export var base_position : Vector2 = Vector2.ZERO

# snapping the inner windows to a 25px grid to fix my ocd
# calling this every frame is dumb but it works and it's not too heavy at least

	
func _process(delta):
	if Engine.is_editor_hint():
		position = base_position * 25.0 #IDK why but resizing the editor window messed up positions so i'm doing it manually
	else:
		position = (round(position / 25) * 25)
	size = (round(size / 25) * 25)
