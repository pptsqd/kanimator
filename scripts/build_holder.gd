class_name Build_Holder
extends Node

var animations_node = self #nicer name, could be used to move targ later
var build_nodes = []
var build_node_dict = {}

func import_build(file: String, image_directory: String) -> void:
	GAME.element_inspector.current_target = null
	build_nodes = []
	build_node_dict = {"kanim_root" : {"node":GAME.build_holder}}
	for child in get_children(): #cull the kids
		remove_child(child)
		child.queue_free() 
		
	var xml = XMLParser.new()

	var file_path = image_directory + "\\" + file
	
	if not xml.open(file_path) == OK:
		#break!
		return

	while xml.read() == OK:
		match xml.get_node_name():
			"Build":
				var build_name = ""
				for i in range(xml.get_attribute_count()):
					if xml.get_attribute_name(i) == "name":
						build_name = xml.get_attribute_value(i)
			"Symbol":
				var symbol_name = ""
				for i in range(xml.get_attribute_count()):
					if xml.get_attribute_name(i) == "name":
						symbol_name = xml.get_attribute_value(i)

				var animated_sprite = KANIMSprite.new()
				build_node_dict[symbol_name] = {"node" : animated_sprite, "id" : build_nodes.size()}
				build_nodes.append(animated_sprite)
				animations_node.add_child(animated_sprite)
				animations_node.move_child(animated_sprite, 0) #reordering so the new item is on top
				animated_sprite.name = symbol_name
				animated_sprite.build_holder = self
				animated_sprite.z_index = 0-build_nodes.size()  #this will let us mess about with parenting
				if GAME.rig_data.has(symbol_name):
					pass
				else:
					GAME.rig_data[symbol_name] = {"parent" : animations_node.name}  #adding the rig here just in case

				parse_symbol_frames(xml, animated_sprite, image_directory)
				animated_sprite.set_frame(0)

# Function to parse frames within a Symbol
func parse_symbol_frames(xml: XMLParser, sprite: KANIMSprite, image_directory: String) -> void:
	# Iterate through the XML nodes to find all "Frame" elements under the current "Symbol"
	while xml.read() == OK:
		# Break out of the loop if we encounter a closing "Symbol" tag
		if xml.get_node_type() == XMLParser.NODE_ELEMENT_END and xml.get_node_name() == "Symbol":
			break
		
		# each element has frames, we'll parse through them here
		if xml.get_node_name() == "Frame":
			var frame_data = {}
			for i in range(xml.get_attribute_count()):
				frame_data[xml.get_attribute_name(i)] = xml.get_attribute_value(i)

			var image_file = frame_data.get("image", "")
			var image_path = "%s\\%s.png" % [image_directory, image_file]
			var image = Image.new()
			image.premultiply_alpha() #hopefully lose the dark outlines
			if image.load(image_path) == OK:
				var texture = ImageTexture.new()
				texture.set_image(image)
				var sprite_data = {"texture" = texture, "w" = frame_data.w, "h" = frame_data.h, "x" = frame_data.x, "y" = frame_data.y}
				sprite.add_frame(sprite_data)
				#some eles have many frames, so i'm appending them here


func load_frame(anim_name, idx):
	#format is anim_data[anim_name]["frames"][current_processed_frame][element_data.name] = {name layername parentname frame depth m1_a m1_b m1_c m1_d m1_tx m1_ty}
	idx = fmod(float(idx),float(GAME.animation_data[anim_name].numframes)) #for saftey, we cap the idx and numframes
	idx = str(int(idx) + int(GAME.animation_data[anim_name].firstframe))
	idx = str(int(idx)) #force int and string
	if GAME.animation_data[anim_name]["frames"].has(idx):
		var frame_data = GAME.animation_data[anim_name]["frames"][idx]
		for element in get_children():
			element.propagate_baked_world(frame_data, 100)  # doing it this way means each element is set in the right place before its kids are which avoids noise

func load_kfa_frame(anim_name, idx):
	idx = fmod(float(idx),float(GAME.keyframe_data[anim_name].numframes)) #for saftey, we cap the idx and numframes
	idx = int(idx)
	for element in build_nodes:
		element.set_from_kfa(idx, anim_name)  # doing it this way means each element is set in the right place before its kids are which avoids noise

func bake_kfa_frame(anim_name, idx):
	load_kfa_frame(anim_name, idx)
	#we're loading the kfa anim frame then for each element we bake its transforms
	#var element_data = processed_data["frames"][frame][element]
	idx = str(idx) #force string cuz the baked ones use strings
	GAME.animation_data[anim_name]["frames"][idx] = {}
	for element in build_nodes:
		#GAME.animation_data[anim_name]["frames"][idx][element.name] = {"name" : element.name}
		var bake_res = element.get_baked_transforms()
		if bake_res != {}:
			GAME.animation_data[anim_name]["frames"][idx][element.name] = bake_res
