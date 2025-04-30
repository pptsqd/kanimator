extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_copy_anim_map_pressed():
	var result = "local name_ANIMS = util.extend( AGENT_ANIMS )\n{\n"
	var anim_names_node = AnimNames.new()
	for animname in anim_names_node.anim_names:
		result += "\t" + str(animname) + " = "
		result += '""'
		result += ",\n"
	result += "}"
	var current_clipboard = DisplayServer.clipboard_get()
	DisplayServer.clipboard_set(str(result)) #pop it in the clipboard
	
