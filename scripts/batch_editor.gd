extends Control


@onready var kfa_batch_edit = %kfa_batchEdit
@onready var kfa_batch_edit_in = %kfa_batchEdit_in
@onready var kfa_batch_edit_out = %kfa_batchEdit_out


func _on_kfa_batch_edit_text_submitted(new_text):
	var kfa_data = GAME.keyframe_data
	var anim_name = GAME.current_keyframe_animname
	var node_name = GAME.element_inspector.current_target.name
	var attr_name = GAME.current_focus_attr
	var from = 0
	var to = 1
	if kfa_data and kfa_data[anim_name] and kfa_data[anim_name][node_name] and kfa_data[anim_name][node_name][attr_name]:
		if kfa_batch_edit_in.text:
			from = kfa_batch_edit_in.text
		if kfa_batch_edit_out.text:
			to = kfa_batch_edit_out.text
		else:
			to = kfa_data[anim_name]["numframes"]
		var expression = Expression.new()
		var check = expression.parse(kfa_batch_edit.text, ["v"])
		if check == OK:
			for key in kfa_data[anim_name][node_name][attr_name]:
				if key >= int(from) and key <= int(to):
					print(key)
					if kfa_data[anim_name][node_name][attr_name][key] is Dictionary and kfa_data[anim_name][node_name][attr_name][key].has("value"):
						var v = kfa_data[anim_name][node_name][attr_name][key].value
						var result = expression.execute([v])
						kfa_data[anim_name][node_name][attr_name][key].value = result
	kfa_batch_edit.text = ""

@onready var kfa_pad_num = %kfa_pad_num
@onready var kfa_pad_at = %kfa_pad_at
@onready var kfa_pad_all = %kfa_pad_all

func insert_time(data):
	var at = int(data.at)
	var num = int(data.num)
	var kfa_data = GAME.keyframe_data
	var anim_name = GAME.current_keyframe_animname
	var list = [GAME.element_inspector.current_target.name]
	var varlist = [GAME.current_focus_attr]
	if data.all:
		list = []
		for element in GAME.build_holder.build_nodes:
			list.append(element.name)
	if data.all_vars:
		varlist = GAME.attr_types
	for node_name in list:
		for attr_name in varlist:
			if kfa_data and kfa_data.has(anim_name) and kfa_data[anim_name].has(node_name) and kfa_data[anim_name][node_name].has(attr_name):
				var from = kfa_data[anim_name]["numframes"]+200 # this is for saftey
				for i in range(from, at, -1):
					if kfa_data[anim_name][node_name][attr_name].has(i):
						kfa_data[anim_name][node_name][attr_name][i+num] = kfa_data[anim_name][node_name][attr_name][i]
						kfa_data[anim_name][node_name][attr_name].erase(i)
						
func shift(data):
	var num = int(data.num)
	var kfa_data = GAME.keyframe_data
	var anim_name = GAME.current_keyframe_animname
	var list = [GAME.element_inspector.current_target.name]
	var varlist = [GAME.current_focus_attr]
	if data.all:
		list = []
		for element in GAME.build_holder.build_nodes:
			list.append(element.name)
	if data.all_vars:
		varlist = GAME.attr_types
	for node_name in list:
		for attr_name in varlist:
			if kfa_data and kfa_data.has(anim_name) and kfa_data[anim_name].has(node_name) and kfa_data[anim_name][node_name].has(attr_name):
				if num > 0:
					var from = kfa_data[anim_name]["numframes"]+200 # this is for saftey
					var to = -200 # this is for saftey
					for i in range(from, to, -1):
						if kfa_data[anim_name][node_name][attr_name].has(i):
							kfa_data[anim_name][node_name][attr_name][i+num] = kfa_data[anim_name][node_name][attr_name][i]
							kfa_data[anim_name][node_name][attr_name].erase(i)
				else:
					var from = -200 
					var to =  kfa_data[anim_name]["numframes"]+200
					for i in range(from, to, 1):
						if kfa_data[anim_name][node_name][attr_name].has(i):
							kfa_data[anim_name][node_name][attr_name][i+num] = kfa_data[anim_name][node_name][attr_name][i]
							kfa_data[anim_name][node_name][attr_name].erase(i)

func set_master_keyframe(data):
	var at = int(data.at)
	var kfa_data = GAME.keyframe_data
	var anim_name = GAME.current_keyframe_animname
	var list = [GAME.element_inspector.current_target.name]
	var varlist = [GAME.current_focus_attr]
	if data.all:
		list = []
		for element in GAME.build_holder.build_nodes:
			list.append(element.name)
	if data.all_vars:
		varlist = GAME.attr_types
	for node_name in list:
		for attr_name in varlist:
			var tosend = {"node_name" : node_name}
			tosend[attr_name] = GAME.keyframe_inspector.get_blend_type()
			print(tosend)
			GAME.keyframes_master.set_keyframe(tosend)
	
	


func erase_after(data):
	var at = int(data.at)
	var kfa_data = GAME.keyframe_data
	var anim_name = GAME.current_keyframe_animname
	var list = [GAME.element_inspector.current_target.name]
	var varlist = [GAME.current_focus_attr]
	if data.all:
		list = []
		for element in GAME.build_holder.build_nodes:
			list.append(element.name)
	if data.all_vars:
		varlist = GAME.attr_types
	for node_name in list:
		for attr_name in varlist:
			if kfa_data and kfa_data.has(anim_name) and kfa_data[anim_name].has(node_name) and kfa_data[anim_name][node_name].has(attr_name):
				var from = kfa_data[anim_name]["numframes"]+200 # this is for saftey
				for i in range(from, at, -1):
					if kfa_data[anim_name][node_name][attr_name].has(i):
						kfa_data[anim_name][node_name][attr_name].erase(i)
						
func erase_before(data):
	var at = int(data.at)
	var kfa_data = GAME.keyframe_data
	var anim_name = GAME.current_keyframe_animname
	var list = [GAME.element_inspector.current_target.name]
	var varlist = [GAME.element_inspector.current_target.name]
	if data.all:
		list = []
		for element in GAME.build_holder.build_nodes:
			list.append(element.name)
	if data.all_vars:
		varlist = GAME.attr_types
	for node_name in list:
		for attr_name in varlist:
			if kfa_data and kfa_data.has(anim_name) and kfa_data[anim_name].has(node_name) and kfa_data[anim_name][node_name].has(attr_name):
				var from = -200 # this is for saftey
				for i in range(from, at, 1):
					if kfa_data[anim_name][node_name][attr_name].has(i):
						kfa_data[anim_name][node_name][attr_name].erase(i)

func _on_kfa_pad_pressed():
	if  kfa_pad_num.text:
		insert_time({"at" : GAME.keyframes_master.current_kfa_frame, "num" : kfa_pad_num.text, "all" : kfa_pad_all.button_pressed, "all_vars" : %kfa_pad_vars.button_pressed})


func _on_kfa_del_before_pressed():
	erase_before({"at" : GAME.keyframes_master.current_kfa_frame, "all" : kfa_pad_all.button_pressed, "all_vars" : %kfa_pad_vars.button_pressed})


func _on_kfa_del_after_pressed():
	erase_after({"at" : GAME.keyframes_master.current_kfa_frame, "all" : kfa_pad_all.button_pressed, "all_vars" : %kfa_pad_vars.button_pressed})

func _on_kfa_global_pressed():
	set_master_keyframe({"at" : GAME.keyframes_master.current_kfa_frame, "all" : kfa_pad_all.button_pressed, "all_vars" : %kfa_pad_vars.button_pressed})


func _on_kfa_shift_pressed():
	if %kfa_shift_num.text:
		shift({"num" : %kfa_shift_num.text, "all" : kfa_pad_all.button_pressed, "all_vars" : %kfa_pad_vars.button_pressed})
