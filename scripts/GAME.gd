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
