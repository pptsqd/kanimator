extends Control


@onready var kfa_batch_edit = %kfa_batchEdit

func _on_kfa_batch_edit_text_submitted(new_text):
	var kfa_data = GAME.keyframe_data
	var anim_name = GAME.current_keyframe_animname
	var node_name = GAME.element_inspector.current_target.name
	var attr_name = GAME.current_focus_attr
	if kfa_data and kfa_data[anim_name] and kfa_data[anim_name][node_name] and kfa_data[anim_name][node_name][attr_name]:
		var expression = Expression.new()
		var check = expression.parse(kfa_batch_edit.text, ["v"])
		if check == OK:
			for key in kfa_data[anim_name][node_name][attr_name]:
				if kfa_data[anim_name][node_name][attr_name][key] is Dictionary and kfa_data[anim_name][node_name][attr_name][key].has("value"):
					var v = kfa_data[anim_name][node_name][attr_name][key].value
					var result = expression.execute([v])
					kfa_data[anim_name][node_name][attr_name][key].value = result
	kfa_batch_edit.text = ""
