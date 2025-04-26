class_name Keyframes_Master
extends Control

@onready var new_anim_name = %newAnimName
const blend_types = ["linear", "ease_in_out", "stepped"]

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
	current_kfa_frame = n
	while current_kfa_frame < 0 :
		current_kfa_frame += frame_count
	current_kfa_frame = int(fmod(float(current_kfa_frame),float(frame_count)))
	kfa_framecount.set_value_no_signal(current_kfa_frame)
	
func _on_kfa_play_pressed():
	playing = !playing
	if playing: %kfa_play.text = "■"
	else: %kfa_play.text = "▶"
	

func _process(delta):
	if playing:
		playing_delta += delta
		if playing_delta > (1.0/frame_rate):
			set_key_frame(current_kfa_frame+1)
			playing_delta -= 1.0/frame_rate
			GAME.build_holder.load_kfa_frame(GAME.current_keyframe_animname, current_kfa_frame)

	if new_anim_name.text == "":
		# adding extra controls for the KFAs
		%kfs_clone.disabled = true
		%kfs_delete.disabled = true
	else:
		if GAME.keyframe_data.has(new_anim_name.text):
			%kfs_clone.disabled = true
			%kfs_delete.disabled = false
		elif GAME.current_keyframe_animname:
			%kfs_clone.disabled = false
			%kfs_delete.disabled = true


func _on_new_animname_text_submitted(new_text):
	print(new_text)
	new_anim_name.text = ""
	if not GAME.keyframe_data.has(new_text):
		GAME.keyframe_data[new_text] = {"numframes" : frame_count,"framerate" : frame_rate}
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


func create_keyframe_basis(node_name, animname):
	if not GAME.keyframe_data[animname].has(node_name):
		GAME.keyframe_data[animname][node_name] = {}
	var poss_keys = ["pos_x", "pos_y", "rot", "scl_x", "scl_y", "idx", "vis"]
	for attr_name in poss_keys:
		if not GAME.keyframe_data[animname][node_name].has(attr_name):
			GAME.keyframe_data[animname][node_name][attr_name] = {}



func edit_keyframe(node_name, attr_name, key_data, blend_type, key_num):
	if str(blend_type) == "Delete":
		GAME.keyframe_data[GAME.current_keyframe_animname][node_name][attr_name].erase_key(key_num)
	GAME.keyframe_data[GAME.current_keyframe_animname][node_name][attr_name][key_num] = {"value" : key_data, "blend" : blend_type}

func set_keyframe(data):
	var node_name = data.node_name
	var node = GAME.build_holder.build_node_dict[node_name].node
	var key_num = current_kfa_frame #GAME.current_keyframe
	if data.has("pos_x"):
		edit_keyframe(node_name, "pos_x", node.position.x, data.pos_x, key_num)
	if data.has("pos_y"):
		edit_keyframe(node_name, "pos_y", node.position.y, data.pos_y, key_num)
	if data.has("rot"):
		edit_keyframe(node_name, "rot", node.rotation_degrees, data.rot, key_num)
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
		set_keyframe({"node_name" : node.name, "pos_x" : 0, "pos_y" : 1, "rot" : 1, "scl_x" : 1, "scl_y" : 1, "idx" : 1, "vis" : 1})
	#print(GAME.keyframe_data)


func get_kfa_data(node_name, attr_name, frame_num):
	if not (GAME.keyframe_data[GAME.current_keyframe_animname][node_name] and GAME.keyframe_data[GAME.current_keyframe_animname][node_name][attr_name]):
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
	var last_key_data = GAME.keyframe_data[str(GAME.current_keyframe_animname)][node_name][attr_name][last_key_num]
	var next_key_data = GAME.keyframe_data[str(GAME.current_keyframe_animname)][node_name][attr_name][next_key_num]
	var keys_delta = 0
	if (next_key_num - last_key_num) > 0:
		keys_delta = ((float(frame_num) - last_key_num)) / ((next_key_num - last_key_num))
	#keys_delta = EasingFunctions.ease_in_out_cubic(keys_delta)
	var result_float = lerpf(last_key_data.value, next_key_data.value, keys_delta)
	#result_float = EasingFunctions.quad_bezier(keys_delta,last_key_data.value,lerpf(last_key_data.value, next_key_data.value, 0.5),next_key_data.value)
	#I think for this we need to find hypothetical key value if the line continued from previous two points
	return result_float

func sort_keys(dict : Dictionary):
	var keys = dict.keys()
	keys.sort()
	return(keys)

func get_first_key(dict: Dictionary):
	var keys = sort_keys(dict)
	return keys[0]
	
func get_last_key(dict: Dictionary):
	var keys = sort_keys(dict)
	print(keys[-1])
	return keys[-1]

func get_latest_key(dict, from):
	var keys = sort_keys(dict)
	var idx = int(floor(float(from)))
	if keys.has(idx):
		return(idx)  #we are on the keyframe
	else:
		for i in range(frame_count*2):
			if keys.has(idx - i):
				return(idx-i)
	return keys[0]

func get_next_key(dict, from):
	var keys = sort_keys(dict)
	var idx = int(ceil(float(from)))
	if keys.has(idx):
		return(idx) #we are a fraction off the keyframe
	else:
		for i in range(frame_count*2):
			if keys.has(idx + i):
				return(idx+i)
	return keys[-1] # get the last keyframe


func _on_kfa_num_frame_spin_value_changed(value):
	frame_count = int(value)
	GAME.keyframe_data[current_anim] = {"numframes" = frame_count}


func _on_kfa_frame_rate_spin_value_changed(value):
	frame_rate = int(value)
	GAME.keyframe_data[current_anim] = {"framerate" = frame_rate}
