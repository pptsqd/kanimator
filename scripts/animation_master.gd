class_name Animation_Master
extends Control

@onready var build_holder = %build_holder

var anim_list = []

var anim_names = []

#
#func _ready():
	#open_all_anim_files()
	
func open_all_anim_files():
	#this is a tool for getting all the anim names, only needed it once but here in case
	var folder_dir = ""
	var dir = DirAccess.open(folder_dir)
	if dir:
		dir.list_dir_begin()
		var subfolder = dir.get_next()
		while subfolder != "":
			if dir.current_is_dir():
				var file_path = folder_dir + subfolder + "/animation.xml"
				if FileAccess.file_exists(file_path):
					var file = FileAccess.open(file_path, FileAccess.READ)
					print("filepath: ", file_path)
					anim_names.append("#" + subfolder)
					import_animation(file_path)
			subfolder = dir.get_next()
		dir.list_dir_end()
	
	print(anim_names)
	var current_clipboard = DisplayServer.clipboard_get()
	DisplayServer.clipboard_set(str(anim_names)) #pop it in the clipboard



@onready var option_button = %OptionButton

func set_options():
	option_button.clear()
	anim_list = []
	for i in GAME.animation_data:
		option_button.add_item(i)
		anim_list.append(i)
	set_baked_anim(0)
	%kf_controls.set_locked(false)

func import_animation(file_path: String):
	GAME.animation_data = {}
	anim_list = []
	var anim_data = {}
	var xml = XMLParser.new()
	
	var anim_name = "" #storing this, it will get updated each pass.
	var current_processed_frame = "" #storing a str seems to work better than an int

	if xml.open(file_path) != OK:
		print("Failed to open XML file:", file_path)
		return anim_data

	while xml.read() == OK:  #loop for reading the XML
		
		# this skips non-xml stuff, probs important
		if xml.get_node_type() != XMLParser.NODE_ELEMENT:
			continue
		
		# match is just a fancy if-then 
		match xml.get_node_name():
			"anim":
				var anim_root = ""
				var numframes = 0
				var framerate = 30
				var frames = {}

				# read all the attributes and store them
				for i in range(xml.get_attribute_count()):
					var attr_name = xml.get_attribute_name(i)
					var attr_value = xml.get_attribute_value(i)
					match attr_name:
						"name":
							anim_name = attr_value
						"root":
							anim_root = attr_value
						"numframes":
							numframes = attr_value.to_int()
						"framerate":
							framerate = attr_value.to_int()
				
				#add the data to the dict with anim_name as a key
				anim_data[anim_name] = {"name" = anim_name, "root" = anim_root, "numframes" = numframes, "firstframe" = 9999999999, "framerate" = framerate, "frames" = frames}
				#add name to list of names
				var clean_name = anim_name
				var directions = ["_SW_", "_NE_", "_SE_", "_SW_", "_S_", "_E_"]
				for dir in directions: 
					clean_name = clean_name.replace(dir, '')
				if not anim_names.has(clean_name):
					anim_names.append(clean_name)
				
			"frame":
				#we're really just getting the index for each frame here.
				for i in range(xml.get_attribute_count()):
					var attr_name = xml.get_attribute_name(i)
					var attr_value = xml.get_attribute_value(i)
					match attr_name:
						"idx":
							current_processed_frame = str(attr_value)
				if int(current_processed_frame) < int(anim_data[anim_name].firstframe):
					anim_data[anim_name].firstframe = current_processed_frame
				#it'd probably be nicer to store this element > frame but we'll match the file format for ease of translation later
				anim_data[anim_name]["frames"][current_processed_frame] = {}

			"element":
				var element_data = {
					"name": "",
					"layername": "",
					"parentname": "",
					"frame": 0,
					"depth": 0,
					"m1_a": 0.0,
					"m1_b": 0.0,
					"m1_c": 0.0,
					"m1_d": 0.0,
					"m1_tx": 0.0,
					"m1_ty": 0.0
				}

				# Extract all attributes of the "element" node
				for i in range(xml.get_attribute_count()):
					var attr_name = xml.get_attribute_name(i)
					var attr_value = xml.get_attribute_value(i)
					match attr_name:
						"name":
							element_data["name"] = attr_value
						"layername":
							element_data["layername"] = attr_value
						"parentname":
							element_data["parentname"] = attr_value
						"frame":
							element_data["frame"] = attr_value.to_int()
						"depth":
							element_data["depth"] = attr_value.to_int()
						"m1_a":
							element_data["m1_a"] = attr_value.to_float()
						"m1_b":
							element_data["m1_b"] = attr_value.to_float()
						"m1_c":
							element_data["m1_c"] = attr_value.to_float()
						"m1_d":
							element_data["m1_d"] = attr_value.to_float()
						"m1_tx":
							element_data["m1_tx"] = attr_value.to_float()
						"m1_ty":
							element_data["m1_ty"] = attr_value.to_float()
				
				#this is messy but I guess it's one less value i'm storing
				anim_data[anim_name]["frames"][current_processed_frame][element_data.name] = element_data

	GAME.animation_data = anim_data
	print("Animation data imported successfully")
	set_options()




func export_animation(file_path: String) -> void:
	
	var file := FileAccess.open(file_path, FileAccess.WRITE)

	# Write the XML header
	file.store_line('<Anims>')
	for anim_name in GAME.animation_data: #do this for each 
		#print(anim_name)
		var processed_data = GAME.animation_data[anim_name]
		file.store_line('\t<anim name="%s" root="%s" numframes="%d" framerate="%d">' % [
			processed_data.get("name", ""),
			processed_data.get("root", ""),
			processed_data.get("numframes", 0),
			processed_data.get("framerate", 30)
		])

		# Write each frame
		#print("HELLO!\n")
		for frame in processed_data["frames"]:  #todo: change this to be for numframes, we can then divest frames to an array per element!
			file.store_line('\t\t<frame idx="' + str(frame) + '" w="0" h="0" x="0" y="0">')
			# w="0" h="0" x="0" y="0" added just in case

			# Write each element inside the frame
			#print(processed_data["frames"][frame])
			for element in processed_data["frames"][frame]:
				var element_data = processed_data["frames"][frame][element]
				file.store_line('\t\t\t<element name="%s" layername="%s" parentname="%s" frame="%d" depth="%d" m1_a="%f" m1_b="%f" m1_c="%f" m1_d="%f" m1_tx="%f" m1_ty="%f" %s/>' % [
					element_data.get("name", ""),
					element_data.get("layername", ""),
					element_data.get("parentname", ""),
					element_data.get("frame", 0),
					element_data.get("depth", 0),
					element_data.get("m1_a", 0.0),
					element_data.get("m1_b", 0.0),
					element_data.get("m1_c", 0.0),
					element_data.get("m1_d", 0.0),
					element_data.get("m1_tx", 0.0),
					element_data.get("m1_ty", 0.0),
					' m0_a="1" m0_b="0" m0_c="0" m0_d="1" m0_tx="0" m0_ty="0" c_01="0" c_02="0" c_03="0" c_10="0" c_12="0" c_13="0" c_20="0" c_21="0" c_23="0" c_30="0" c_31="0" c_32="0" c_40="0" c_41="0" c_42="0" c_43="0" c_44="1" c_00="1" c_11="1" c_22="1" c_33="1" c_04="0" c_14="0" c_24="0" c_34="0"'
				]) #re-adding the junk(?) at the end just in case
				#c_33="0.5" is half opacity???
				#todo: export <pupp_keyframes> with <element><frame "parent" "ease" "sprite_frame" "position/rotation/scale" ...> for loading with editor 
				#OR just use JSON and a seperatefile type
			file.store_line('</frame>')

		# Close the anim node
		file.store_line('</anim>')
	file.store_line('</Anims>')

	# Close the file
	file.close()

	print("Animation data exported successfully to:", file_path)


func _on_save_dialogue_file_selected(path):
	export_animation(path)


func on_save_pressed():
	%SaveDialogue.popup()

var current_frame = 0
var playing_delta = 0.0
var current_anim = 0
var playing = false
var frame_count = 100
var frame_rate = 30

func _on_apply_pressed():
	if anim_list == []:
		return false
	set_baked_frame(bkd_framecount.value)
	GAME.build_holder.load_frame(anim_list[current_anim], current_frame)
	current_frame += 1

func set_baked_frame(n):
	current_frame = n
	while current_frame < 0 :
		current_frame += frame_count
	current_frame = int(fmod(float(current_frame),float(frame_count)))
	bkd_framecount.set_value_no_signal(current_frame)
	
@onready var bkd_framecount = %bkd_framecount

func _on_baked_play_pressed():
	playing = !playing
	if playing: %baked_play.text = "■"
	else: %baked_play.text = "▶"
		

var baking = false
var bake_frame = 0
var bake_length = 0
var bake_name = ""
var bake_result = {}

func bake_kfa():
	var anim_name = GAME.keyframes_master.current_anim
	bake_result = {"name" = anim_name, "firstframe" = 0, "frames" = {}}
	bake_result["numframes"] = GAME.keyframe_data[anim_name]["numframes"]
	bake_result["framerate"] = GAME.keyframe_data[anim_name]["framerate"]
	bake_result["root"] = GAME.keyframe_data[anim_name]["root"]
	#GAME.animation_data[anim_name] = bake_result #holdover from direct bakes
	bake_length = bake_result["numframes"]
	bake_name = anim_name
	bake_frame = 0
	baking = true
	#for frame in bake_result["numframes"]:
		#GAME.build_holder.bake_kfa_frame(anim_name, frame)
	#GAME.animation_data[anim_name] = bake_result
	#set_options()
#%SaveDialogue.popup()

func save_bakes():
	var dir_list = []
	var directions = GAME.keyframe_data[bake_name]["dirs"]
	for dir in directions:
		if directions[dir] == true:
			dir_list.append(dir)
	if dir_list.size() == 0: #bake the exact name if there's no dirs
		GAME.animation_data[bake_name] = bake_result
	else:
		#for dir in dir_list:
			#var bake_name_dir = bake_name + "_" + dir + "_" #the trailing _ isnt always there idk if it's needed
			#GAME.animation_data[bake_name_dir] = bake_result.duplicate(true)
			#GAME.animation_data[bake_name_dir]["name"] = bake_name_dir
			
		var bake_name_dir = bake_name.get_slice("~",0) + "_" #this ver would make a single anim instead of one each, idk if it's better
		for dir in dir_list:
			bake_name_dir = bake_name_dir + dir + "_" #the trailing _ isnt always there idk if it's needed
		GAME.animation_data[bake_name_dir] = bake_result.duplicate(true)
		GAME.animation_data[bake_name_dir]["name"] = bake_name_dir

func _process(delta):
	if baking:
		if bake_frame < bake_length:
			GAME.build_holder.bake_kfa_frame(bake_name, bake_frame)
			bake_frame += 1
		else:
			baking = false
			save_bakes()
			set_options()
		
	elif playing:
		playing_delta += delta
		if playing_delta > (1.0/frame_rate):
			set_baked_frame(current_frame+1)
			playing_delta -= 1.0/frame_rate
			GAME.build_holder.load_frame(anim_list[current_anim], current_frame)
		

func _on_baked_anim_selected(index):
	set_baked_anim(index)
	
func set_baked_anim(index):
	current_anim = index
	current_frame = 0
	var anim_name = anim_list[current_anim]
	frame_count = GAME.animation_data[anim_name]["numframes"]
	frame_rate = int(GAME.animation_data[anim_name]["framerate"])
	%bkd_nFrames.text = "nFrames: " + str(frame_count)
	%bkd_fRate.text = "fRate: " + str(frame_rate)



func _on_baked_bwd_pressed():
	set_baked_frame(current_frame-1)
	GAME.build_holder.load_frame(anim_list[current_anim], current_frame)


func _on_baked_fwd_pressed():
	set_baked_frame(current_frame+1)
	GAME.build_holder.load_frame(anim_list[current_anim], current_frame)


func _on_bake_anim_pressed():
	bake_kfa()
