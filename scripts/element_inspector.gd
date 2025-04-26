class_name Element_Inspector
extends Control

@onready var spin_pos_x = %spin_pos_x
@onready var spin_pos_y = %spin_pos_y
@onready var spin_rot = %spin_rot
@onready var spin_scl_x = %spin_sclx
@onready var spin_scl_y = %spin_scly
@onready var spin_idx = %spin_idx
@onready var chk_vis = %chk_vis
@onready var parent_selector : OptionButton = %parentselector
var current_target : KANIMSprite

var parents_list = []

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_parent_options(array):
	parent_selector.clear()
	parents_list.append(GAME.build_holder)
	parent_selector.add_item(GAME.build_holder.name)
	for i in array:
		parents_list.append(i)
		parent_selector.add_item(i.name)
		
func change_target(new_target : KANIMSprite):
	current_target = new_target
	%element_name.text = "Name: " + current_target.name
	parent_selector.select(parents_list.find(current_target.get_parent(),0))



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_instance_valid(current_target):
		spin_pos_x.set_value_no_signal(current_target.position.x)
		spin_pos_y.set_value_no_signal(-current_target.position.y)
		spin_rot.set_value_no_signal(current_target.rotation_degrees)
		spin_scl_x.set_value_no_signal(current_target.scale.x)
		spin_scl_y.set_value_no_signal(current_target.scale.y)
		spin_idx.set_value_no_signal(current_target.frame)
		chk_vis.set_pressed_no_signal(current_target.sprite_visible)


func _on_spin_pos_x_value_changed(value):
	if is_instance_valid(current_target):
		current_target.position.x = value
func _on_spin_pos_y_value_changed(value):
	if is_instance_valid(current_target):
		current_target.position.y = -value

func _on_spin_rot_value_changed(value):
	if is_instance_valid(current_target):
		current_target.rotation_degrees = value

func _on_spin_scl_value_changed(value):
	if is_instance_valid(current_target):
		current_target.scale = Vector2(spin_scl_x.value,spin_scl_y.value)


func _on_spin_idx_value_changed(value):
	if is_instance_valid(current_target):
		var res = current_target.set_frame(int(value))
		if res == false:
			spin_idx.set_value_no_signal(0)


func _on_chk_vis_toggled(toggled_on):
	if is_instance_valid(current_target):
		current_target.set_sprite_vis(toggled_on)
