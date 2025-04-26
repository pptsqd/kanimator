extends Node


var element_selector : Element_Selector
var animation_master : Animation_Master
var element_inspector : Element_Inspector
var keyframes_master : Keyframes_Master

var build_holder : Build_Holder
var animation_data = {}
var keyframe_data = {}
var rig_data = {}

var current_frame : int = 0

var current_keyframe : int = 0
var current_keyframe_animname = ""

const blend_types = ["linear", "ease_in_out", "ease_in", "ease_out", "stepped", "ease_i_o_cubic", "ease_in_cubic", "ease_out_cubic"]
const attr_types = ["pos_x", "pos_y", "rot", "scl_x", "scl_y", "idx", "vis"]
var current_focus_attr = "pos_x"
