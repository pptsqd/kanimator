class_name Keyframe_Inspector
extends Control

@onready var kf_element_name = %kf_element_name
@onready var kf_ele_selector = %kf_ele_selector
@onready var kf_latest = %kf_latest
@onready var kf_num = %kf_num
@onready var kf_next = %kf_next
@onready var kf_update = %kf_update
@onready var kf_delete = %kf_delete
@onready var kf_easing_sel = %kf_easing_sel

var focus_attribute = "rot"

# Called when the node enters the scene tree for the first time.
func _ready():
	for val in GAME.attr_types:
		kf_ele_selector.add_item(val)
	for val in GAME.blend_types:
		kf_easing_sel.add_item(val)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_kf_latest_pressed():
	GAME.keyframes_master.go_to_prev_key(GAME.element_inspector.current_target.name, GAME.current_focus_attr)


func _on_kf_next_pressed():
	GAME.keyframes_master.go_to_next_key(GAME.element_inspector.current_target.name, GAME.current_focus_attr)


func _on_kf_ele_selector_item_selected(index):
	GAME.current_focus_attr = GAME.attr_types[index]


func _on_kf_update_pressed():
	var key_info = {"node_name" : GAME.element_inspector.current_target.name}
	key_info[GAME.current_focus_attr] = kf_easing_sel.selected
	GAME.keyframes_master.set_keyframe(key_info)

func _on_kf_delete_pressed():
	var key_info = {"node_name" : GAME.element_inspector.current_target.name}
	key_info[GAME.current_focus_attr] = -1
	GAME.keyframes_master.set_keyframe(key_info)
