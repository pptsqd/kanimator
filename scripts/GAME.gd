extends Node


var element_selector : Element_Selector
var animation_master : Animation_Master
var element_inspector : Element_Inspector
var keyframes_master : Keyframes_Master
var keyframe_inspector : Keyframe_Inspector
var kfa_data_editor : KFA_Data_Editor

var build_holder : Build_Holder
var animation_data = {}
var keyframe_data = {}
var rig_data = {}

var current_frame : int = 0

var current_keyframe : int = 0
var current_keyframe_animname = ""

const blend_types = ["linear", "ease_in_out", "ease_in", "ease_out", "stepped"]
const ease_types = ["sine", "cubic", "circ", "quart", "quint"]
const attr_types = ["pos_x", "pos_y", "rot", "skw", "scl_x", "scl_y", "idx", "vis"]
var current_focus_attr = "pos_x"

const default_dirs = {"N":false, "NE":false, "E":false, "SE":false, "S":false, "SW":false, "W":false, "NW":false}


var KFA_history = []
func save_history():
	KFA_history.append(keyframe_data.duplicate(true))
	if KFA_history.size() > 50:
		KFA_history.pop_front()

func undo_KFA():
	if KFA_history.size() > 1:
		keyframe_data = KFA_history.pop_back()
