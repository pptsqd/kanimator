class_name Keyframes_Master
extends Control

@onready var new_anim_name = %newAnimName

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

@onready var kfa_framecount = %kfa_framecount
@onready var kfa_num_frame_spin = %kfa_numFrameSpin
@onready var kfa_frame_rate_spin = %kfa_frameRateSpin


var playing = false
var playing_delta = 0.0
var frame_rate = 30
var frame_count = 100
var current_kfa_frame = 0
var current_anim = ""

func set_key_frame(n):
	current_kfa_frame = int(n)
	while current_kfa_frame < 0 :
		current_kfa_frame += frame_count
	current_kfa_frame = int(fmod(float(current_kfa_frame),float(frame_count)))
	kfa_framecount.set_value_no_signal(current_kfa_frame)
	
func _on_kfa_play_pressed():
	playing = !playing
	

func _process(delta):
	if playing:
		%kfa_play.text = "■"
		playing_delta += delta
		if playing_delta > (1.0/frame_rate):
			set_key_frame(current_kfa_frame+1)
			playing_delta -= 1.0/frame_rate
			GAME.build_holder.load_kfa_frame(GAME.current_keyframe_animname, current_kfa_frame)
	else: %kfa_play.text = "▶"
	
	
	if new_anim_name.text == "":
		%kfs_clone.disabled = true
		%kfs_delete.disabled = true
		%kfs_append.disabled = true
	else:
		if GAME.keyframe_data.has(new_anim_name.text):
			%kfs_clone.disabled = true
			if new_anim_name.text == GAME.current_keyframe_animname:
				%kfs_delete.disabled = false
				%kfs_append.disabled = true
			else:
				%kfs_append.disabled = false
				%kfs_delete.disabled = true
		elif GAME.current_keyframe_animname:
			%kfs_clone.disabled = false
			%kfs_delete.disabled = true
			%kfs_append.disabled = true


func _on_new_animname_text_submitted(new_text):
	#print(new_text)
	new_anim_name.text = ""
	if not GAME.keyframe_data.has(new_text):
		GAME.keyframe_data[new_text] = {"numframes" : frame_count,"framerate" : frame_rate, "root" : "character", "dirs" : GAME.default_dirs.duplicate()}
		%keyframeanim_selector.add_item(new_text, -1)
		for node in GAME.build_holder.build_nodes:
			create_keyframe_basis(node.name, new_text)
		%keyframeanim_selector.select(%keyframeanim_selector.item_count-1)
	change_kfanim(new_text)

func change_kfanim(name):
	playing = false
	GAME.current_keyframe = 0
	GAME.current_keyframe_animname = name
	current_anim = name
	%kfa_bounds.set_locked(false)
	%kfa_controls.set_locked(false)
	%kfa_tools.set_locked(false)
	kfa_num_frame_spin.set_value(GAME.keyframe_data[name]["numframes"])
	kfa_frame_rate_spin.set_value(GAME.keyframe_data[name]["framerate"])
	GAME.kfa_data_editor.update()

func load_kfas():
	%keyframeanim_selector.clear()
	for anim in GAME.keyframe_data:
		%keyframeanim_selector.add_item(anim, -1)
	change_kfanim(%keyframeanim_selector.get_item_text(0))

func create_keyframe_basis(node_name, animname):
	if not GAME.keyframe_data[animname].has(node_name):
		GAME.keyframe_data[animname][node_name] = {}
	var poss_keys = GAME.attr_types
	for attr_name in poss_keys:
		if not GAME.keyframe_data[animname][node_name].has(attr_name):
			GAME.keyframe_data[animname][node_name][attr_name] = {}

func delete_kfa(animname):
	if GAME.keyframe_data.has(animname):
		GAME.keyframe_data.erase(animname)
	load_kfas()
	if GAME.keyframe_data.size() > 0:
		change_kfanim(%keyframeanim_selector.get_item_text(0))
	
func clone_kfa(new_animname):
	deep_kfa_copy(GAME.keyframe_data,GAME.keyframe_data,GAME.current_keyframe_animname,new_animname,{})
	load_kfas()
	change_kfanim(new_animname)

func deep_kfa_copy(source_dict,target_dict,from_name,to_name,extra_data):
	#a standard duplicate leaves sub-values linked, this is a brand new dict being made
	target_dict[to_name] = {"framerate" = source_dict[from_name]["framerate"],"numframes" = source_dict[from_name]["numframes"]}
	if source_dict[from_name].has("root"):
		target_dict[to_name]["root"] = source_dict[from_name]["root"]
		target_dict[to_name]["dirs"] = source_dict[from_name]["dirs"].duplicate(true)
	var paste_offset = 0
	var range = false
	var range_start = 0
	var range_end = 0
	for nodename in source_dict[from_name]:
		if not ["framerate","numframes","root","dirs"].has(nodename):
			target_dict[to_name][nodename] = {}
			for attr in source_dict[from_name][nodename]:
				target_dict[to_name][nodename][attr] = {}
				for key_num in source_dict[from_name][nodename][attr]:
					#if range == false or (key_num >= range_start and key_num <= range_end): 
					target_dict[to_name][nodename][attr][int(key_num)+paste_offset] = source_dict[from_name][nodename][attr][key_num].duplicate(true)
					#making sure the frame num key is an int to make maths easy

func kfa_append(source_dict,target_dict,from_name,to_name,extra_data):
	#a standard duplicate leaves sub-values linked, this is a brand new dict being made
	var paste_offset = 0
	var range = false
	var range_start = 0
	var range_end = 0
	if extra_data.has("append"):
		paste_offset = target_dict[to_name]["numframes"]
		target_dict[to_name]["numframes"] = target_dict[to_name]["numframes"] + source_dict[from_name]["numframes"]
	if extra_data.has("range"):
		range_start = extra_data.range.x
		range_end = extra_data.range.y
		range = true
	for nodename in source_dict[from_name]:
		if not (nodename == "framerate" or nodename == "numframes"):
			if not target_dict[to_name].has(nodename):
				target_dict[to_name][nodename] = {}
			for attr in source_dict[from_name][nodename]:
				if not target_dict[to_name][nodename].has(attr):
					target_dict[to_name][nodename][attr] = {}
				for key_num in source_dict[from_name][nodename][attr]:
					#if range == false or (key_num >= range_start and key_num <= range_end): 
					target_dict[to_name][nodename][attr][int(key_num)+paste_offset] = source_dict[from_name][nodename][attr][key_num]
					#making sure the frame num key is an int to make maths easy

func edit_keyframe(node_name, attr_name, key_data, blend_type, key_num):
	#print(node_name)
	if not GAME.keyframe_data[GAME.current_keyframe_animname].has(node_name):
		create_keyframe_basis(node_name, GAME.current_keyframe_animname)
	if str(blend_type) == "delete":
		GAME.keyframe_data[GAME.current_keyframe_animname][node_name][attr_name].erase(key_num)
	else:
		if not GAME.keyframe_data[GAME.current_keyframe_animname][node_name].has(attr_name):
			GAME.keyframe_data[GAME.current_keyframe_animname][node_name][attr_name] = {}
		GAME.keyframe_data[GAME.current_keyframe_animname][node_name][attr_name][int(key_num)] = {"value" : key_data, "blend" : blend_type}

func set_keyframe(data):
	var node_name = data.node_name
	var node = GAME.build_holder.build_node_dict[node_name].node
	var key_num = int(current_kfa_frame) #GAME.current_keyframe
	if data.has("key_num"):
		key_num = data.key_num
	if data.has("pos_x"):
		edit_keyframe(node_name, "pos_x", node.position.x, data.pos_x, key_num)
	if data.has("pos_y"):
		edit_keyframe(node_name, "pos_y", node.position.y, data.pos_y, key_num)
	if data.has("rot"):
		edit_keyframe(node_name, "rot", node.rotation_degrees, data.rot, key_num)
	if data.has("skw"):
		edit_keyframe(node_name, "skw", node.skew, data.skw, key_num)
	if data.has("scl_x"):
		edit_keyframe(node_name, "scl_x", node.scale.x, data.scl_x, key_num)
	if data.has("scl_y"):
		edit_keyframe(node_name, "scl_y", node.scale.y, data.scl_y, key_num)
	if data.has("idx"):
		edit_keyframe(node_name, "idx", node.frame, data.idx, key_num)
	if data.has("vis"):
		edit_keyframe(node_name, "vis", int(node.sprite_visible), data.vis, key_num)
		

func _on_set_global_kf_pressed():
	for node in GAME.build_holder.build_nodes:
		set_keyframe({"node_name" : node.name, "pos_x" : 0, "pos_y" : 0, "rot" : 0, "skw" : 0, "scl_x" : 0, "scl_y" : 0, "idx" : 0, "vis" : 0})
	#print(GAME.keyframe_data)


func get_kfa_data(node_name, attr_name, frame_num):
	if not GAME.keyframe_data:
		return 0
	if not (GAME.keyframe_data[GAME.current_keyframe_animname].has(node_name) and GAME.keyframe_data[GAME.current_keyframe_animname][node_name].has(attr_name)):
		if attr_name == "scl_x" or attr_name == "scl_y":
			return 1 # override default for scale when data is missing
		return 0
	var raw_data = GAME.keyframe_data[GAME.current_keyframe_animname][node_name][attr_name]
	if raw_data.size() == 0: #no data
		if attr_name == "scl_x" or attr_name == "scl_y":
			return 1 # override default for scale when data is missing
		return 0
	var last_key_num = get_latest_key(raw_data, frame_num)
	var next_key_num = get_next_key(raw_data, frame_num)
	var last_key_data = raw_data[last_key_num]
	var next_key_data = raw_data[next_key_num]
	var keys_delta = 0
	if (int(next_key_num) - int(last_key_num)) > 0:
		keys_delta = ((float(frame_num) - int(last_key_num))) / ((int(next_key_num) - int(last_key_num)))
	if last_key_data["blend"]:
		var blend_type = last_key_data["blend"]
		var easingFuncs = EasingFunctions.new()
		if easingFuncs.has_method(blend_type):
			var callable = Callable(EasingFunctions, blend_type)
			keys_delta = callable.call(keys_delta)
		#this is kinda gross but it lets us add new easing super easy
		#this won't work with bezier and that might be an IF override
	var result_float = lerpf(last_key_data.value, next_key_data.value, keys_delta)
	#result_float = EasingFunctions.quad_bezier(keys_delta,last_key_data.value,lerpf(last_key_data.value, next_key_data.value, 0.5),next_key_data.value)
	#I think for this we need to find hypothetical key value if the line continued from previous two points
	return result_float

var focused_attribute = ""

func go_to_prev_key(node_name, attr_name):
	playing = false
	if not (GAME.keyframe_data[GAME.current_keyframe_animname].has(node_name) and GAME.keyframe_data[GAME.current_keyframe_animname][node_name][attr_name]):
		return 0
	var raw_data = GAME.keyframe_data[GAME.current_keyframe_animname][node_name][attr_name]
	var last_key_num = get_latest_key(raw_data, current_kfa_frame-1)
	set_key_frame(last_key_num)
	GAME.build_holder.load_kfa_frame(GAME.current_keyframe_animname, current_kfa_frame)
	
func go_to_next_key(node_name, attr_name):
	playing = false
	if not (GAME.keyframe_data[GAME.current_keyframe_animname][node_name] and GAME.keyframe_data[GAME.current_keyframe_animname][node_name][attr_name]):
		return 0
	var raw_data = GAME.keyframe_data[GAME.current_keyframe_animname][node_name][attr_name]
	var next_key_num = get_next_key(raw_data, current_kfa_frame+1)
	set_key_frame(next_key_num)
	GAME.build_holder.load_kfa_frame(GAME.current_keyframe_animname, current_kfa_frame)

func sort_keys(dict : Dictionary):
	var keys = dict.keys()
	keys.sort()
	return(keys)

func get_first_key(dict: Dictionary):
	var keys = sort_keys(dict)
	return int(keys[0])
	
func get_last_key(dict: Dictionary):
	var keys = sort_keys(dict)
	#print(keys[-1])
	return int(keys[-1])

func get_latest_key(dict, from):
	var keys = sort_keys(dict)
	var idx = int(floor(float(from)))
	if keys.has(str(idx)):
		return(int(idx))  #we are on the keyframe
	else:
		for i in range(frame_count*2):
			if keys.has(idx - i):
				return(idx-i)
	return int(keys[0])

func get_next_key(dict, from):
	var keys = sort_keys(dict)
	var idx = int(ceil(float(from)))
	if keys.has(str(idx)):
		return(int(idx)) #we are a fraction off the keyframe
	else:
		for i in range(frame_count*2):
			if keys.has(idx + i):
				return(idx+i)
	return int(keys[-1]) # get the last keyframe



func _on_kfa_num_frame_spin_value_changed(value):
	frame_count = int(value)
	GAME.keyframe_data[current_anim]["numframes"] = frame_count


func _on_kfa_frame_rate_spin_value_changed(value):
	frame_rate = int(value)
	GAME.keyframe_data[current_anim]["framerate"] = frame_rate

func _on_kfa_framecount_value_changed(value):
	current_kfa_frame = int(value)  #direct set, we bypass the limits here


func _on_kfm_bwd_pressed():
	playing = false
	set_key_frame(current_kfa_frame-1)
	GAME.build_holder.load_kfa_frame(GAME.current_keyframe_animname, current_kfa_frame)
	

func _on_kfm_apply_pressed():
	GAME.build_holder.load_kfa_frame(GAME.current_keyframe_animname, current_kfa_frame)

func _on_kfm_fwd_pressed():
	playing = false
	set_key_frame(current_kfa_frame+1)
	GAME.build_holder.load_kfa_frame(GAME.current_keyframe_animname, current_kfa_frame)


func _on_keyframeanim_selector_item_selected(index):
	change_kfanim(%keyframeanim_selector.get_item_text(index))


func _on_kfs_delete_pressed():
	delete_kfa(new_anim_name.text)
	new_anim_name.text = ""


func _on_kfs_clone_pressed():
	print("CLONE")
	clone_kfa(new_anim_name.text)
	new_anim_name.text = ""
	%keyframeanim_selector.select(%keyframeanim_selector.item_count-1)
	


func _on_kfs_append_pressed():
	kfa_append(GAME.keyframe_data,GAME.keyframe_data,GAME.current_keyframe_animname,new_anim_name.text,{"append":true})
	new_anim_name.text = ""
	load_kfas()
