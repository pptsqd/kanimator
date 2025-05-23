class_name Element_Button
extends Control


var target_node : KANIMSprite
@onready var parent_selector = %OptionButton

func setup(data):
	%Button.text = data.name
	target_node = data.node
	target_node.element_button = self
	%Button.disabled = false


func _on_button_pressed():
	GAME.element_inspector.change_target(target_node)

func set_parent_options():
	parent_selector.clear()
	for i in GAME.element_selector.parents_list:
		parent_selector.add_item(i.name)
		

func _on_parent_selector_item_selected(index):
	target_node.change_rig_parent(GAME.element_selector.parents_list[index])

func update_parent():
	#this is very backwards but whatever it's done
	var id = 0
	var to_parent = "kanim_root"
	if GAME.rig_data.has(target_node.name):
		to_parent = GAME.rig_data[target_node.name].parent
	if to_parent == "kanim_root":
		pass
	else:
		id = GAME.build_holder.build_node_dict[GAME.rig_data[target_node.name].parent].id  #I can't think of a nicer way to do this.
		#well, I can, but i can't think of a way that means I don't have to change a bunch of stuff
	parent_selector.select(id)
	GAME.build_holder.build_node_dict[target_node.name].node.change_rig_parent(GAME.build_holder.build_node_dict[to_parent].node)
	#SO. I have a dict that points us to the build nodes, im using that here.


func _on_duplicate_pressed():
	var old_name = target_node.name
	var new_name = target_node.name
	var suffix = old_name.substr(old_name.length() - 2, 2)
	if int(suffix) == 00:
		var number = int(suffix) + 1
		var new_suffix = "%02d" % number
		new_name = old_name.substr(0, old_name.length() - 2) + str(new_suffix)
	else:
		new_name = old_name + "_01"
	print(new_name)
	GAME.build_holder.duplicate_kanimsprite(target_node, new_name)
