class_name Element_Selector
extends Control
@onready var v_box_container = %element_button_holder

const ELEMENT_BUTTON = preload("res://element_button.tscn")
var button_list = []
var parents_list = []

func clear_buttons():
	button_list = []
	parents_list = [GAME.build_holder]
	for child in v_box_container.get_children():
		remove_child(child)
		child.queue_free() 
		
func add_button(data):
	var new_button = ELEMENT_BUTTON.instantiate()
	new_button.setup(data)
	v_box_container.add_child(new_button)
	v_box_container.move_child(new_button, 0) #reordering so the new item is on top
	button_list.append(new_button)
	parents_list.append(data.node)
	set_parent_options()
	
func set_parent_options():
	for button in button_list:
		button.set_parent_options()

func load_rig(): #im sorry you have to see this
	for button in button_list:
		button.update_parent()
