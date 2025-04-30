extends Control

@onready var element_selector = %element_selector
@onready var animation_master = %animation_master



# Called when the node enters the scene tree for the first time.
func _ready():
	GAME.element_inspector = %element_inspector
	GAME.keyframe_inspector = %keyframe_inspector
	GAME.build_holder = %kanim_root
	GAME.element_selector = %element_selector
	GAME.keyframes_master = %keyframes_master
	GAME.kfa_data_editor = %kfa_data_editor

@onready var tile = %tile
@onready var portrait_bounds = %portrait_bounds
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	portrait_bounds.visible = %show_bounds.button_pressed
	tile.visible = %show_tile.button_pressed



func _on_file_dialog_file_selected(path):
	print(path)
	var last_slash_index = path.rfind("\\")
	var directory = path.substr(0, last_slash_index)
	var filename = path.substr(last_slash_index + 1, path.length())
	
	var file_path = directory + "\\" + filename
	print (file_path)
	GAME.build_holder.import_build(filename, directory)
	
	element_selector.clear_buttons()
	for child in GAME.build_holder.get_children():
		var data = {"name" = child.name, "node" = child}
		element_selector.add_button(data)
	


func _on_button_pressed():
	%FileDialog.popup()


@onready var kanim_rendercam = %kanim_rendercam
func _on_anim_resize_value_changed(value):
	kanim_rendercam.zoom = Vector2(1.0,1.0) * value * 0.01


func _on_load_anims_pressed():
	%AnimDialogue.popup()


func _on_anim_dialogue_file_selected(path):
	animation_master.import_animation(path)


func _on_apply_pressed():
	pass # Replace with function body.


func _on_viewer_v_scroll_bar_value_changed(value):
	kanim_rendercam.position.y = (value-50)*-5


func _on_viewer_h_scroll_bar_value_changed(value):
	kanim_rendercam.position.x = (value-50)*-5




func _on_save_rig_pressed():
	%SaveRigDialogue.popup()


func _on_load_rig_pressed():
	%LoadRigDialogue.popup()

func _on_save_rig_dialogue_file_selected(path):
	var save_file = FileAccess.open(path, FileAccess.WRITE)
	if save_file == null:
		print ("Error making save file ", FileAccess.get_open_error())
	else:
		var json_string = JSON.stringify(GAME.rig_data)
		save_file.store_string(json_string)

func _on_load_rig_dialogue_file_selected(path):
	if FileAccess.file_exists(path):
		var save_file = FileAccess.open(path, FileAccess.READ)
		var json_string = save_file.get_as_text()
		var json = JSON.new()
		var parse_result = json.parse(json_string)
		if parse_result == OK:
			GAME.rig_data = json.get_data()
			GAME.element_selector.load_rig()  #im using Element Selector to do this because
		else:
			print("JSON parse error; ", json.get_error_message())
			


func _on_load_keys_pressed():
	%LoadKfasDialogue.popup()


func _on_save_keys_pressed():
	%SaveKfasDialogue.popup()

func _on_save_kfas_dialogue_file_selected(path):
	var save_file = FileAccess.open(path, FileAccess.WRITE)
	if save_file == null:
		print ("Error making save file ", FileAccess.get_open_error())
	else:
		var json_string = JSON.stringify(GAME.keyframe_data)
		save_file.store_string(json_string)


func _on_load_kfas_dialogue_file_selected(path):
	if FileAccess.file_exists(path):
		var save_file = FileAccess.open(path, FileAccess.READ)
		var json_string = save_file.get_as_text()
		var json = JSON.new()
		var parse_result = json.parse(json_string)
		if parse_result == OK:
			var imported_dict = json.get_data()
			GAME.keyframe_data = {}
			#JSON is saved as strings, so I'm decompiling this to keep int dict keys to make my life easier
			#my deep-copy script does this by default so i'm using that for ease
			for anim in imported_dict:
				GAME.keyframes_master.deep_kfa_copy(imported_dict,GAME.keyframe_data,anim,anim,{})
			GAME.keyframes_master.load_kfas()  #im using Element Selector to do this because
		else:
			print("JSON parse error; ", json.get_error_message())
