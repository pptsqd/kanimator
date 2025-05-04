class_name KFA_Data_Editor
extends Control

@onready var rootname = %rootname
var dir_boxes = {}

func _ready():
	dir_boxes["N"] = %N_
	dir_boxes["E"] = %E_
	dir_boxes["S"] = %S_
	dir_boxes["W"] = %W_
	dir_boxes["NE"] = %NE_
	dir_boxes["NW"] = %NW_
	dir_boxes["SE"] = %SE_
	dir_boxes["SW"] = %SW_
	for dir in dir_boxes:
		dir_boxes[dir].pressed.connect(Callable(self,"_on_check_box_toggled"))
	%addFlipSW.pressed.connect(Callable(self, "on_flipped_sw_toggled"))

func update():
	if GAME.current_keyframe_animname:
		var animname = GAME.current_keyframe_animname
		if GAME.keyframe_data.has(animname) and GAME.keyframe_data[animname].has("data"):
			var kfdata = GAME.keyframe_data[animname]["data"]
			if not kfdata.has("root"):  #this wasn't part of old builds of the program
				kfdata["root"] = "character"
			if not kfdata.has("dirs"):
				kfdata["dirs"] = GAME.default_dirs.duplicate()
			if not kfdata.has("flipped_SW"):
				kfdata["flipped_SW"] = false
			for dir in dir_boxes:
				dir_boxes[dir].button_pressed = kfdata["dirs"][dir]
			%addFlipSW.button_pressed = kfdata["flipped_SW"]
			rootname.text = kfdata["root"]

func _on_check_box_toggled():
	if GAME.current_keyframe_animname:
		var animname = GAME.current_keyframe_animname
		if GAME.keyframe_data.has(animname) and GAME.keyframe_data[animname].has("data"):
			var kfdata = GAME.keyframe_data[animname]["data"]
			for dir in dir_boxes:
				kfdata["dirs"][dir] = dir_boxes[dir].button_pressed

func on_flipped_sw_toggled():
	if GAME.current_keyframe_animname:
		var animname = GAME.current_keyframe_animname
		if GAME.keyframe_data.has(animname) and GAME.keyframe_data[animname].has("data"):
			var kfdata = GAME.keyframe_data[animname]["data"]
			kfdata["flipped_SW"] = %addFlipSW.button_pressed

func _on_rootname_text_submitted(new_text):
	if GAME.current_keyframe_animname:
		var animname = GAME.current_keyframe_animname
		if GAME.keyframe_data.has(animname) and GAME.keyframe_data[animname].has("data"):
			var kfdata = GAME.keyframe_data[animname]["data"]
			kfdata["root"] = new_text
			rootname.release_focus()
