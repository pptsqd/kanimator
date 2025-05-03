class_name KANIMSprite
extends Node2D


var transformation_matrix : Transform2D
var animated_sprite : AnimatedSprite2D
var frames_info = [] #storing the offsets in an array to match the frames
var build_holder : Build_Holder
var frame : int = 0
var numframes : int = 0
var rig_parent : Node
var element_button : Element_Button
var sprite_visible = true

# Called when the node enters the scene tree for the first time.
func _ready():
	animated_sprite = AnimatedSprite2D.new()  #spawning in the sprite as a child to apply offsets
	add_child(animated_sprite)
	animated_sprite.sprite_frames = SpriteFrames.new()
	#we need blank sprite frames to load onto so i'm making it automatically
	rig_parent = GAME.build_holder
	z_as_relative = false

func change_rig_parent(new_parent):
	rig_parent.remove_child(self)
	new_parent.add_child(self)
	rig_parent = new_parent
	GAME.rig_data[name] = {"parent" : new_parent.name} #update the rig data to match

func add_frame(sprite_data):
	animated_sprite.sprite_frames.add_frame("default", sprite_data.texture)
	frames_info.append(sprite_data)
	numframes += 1

func set_frame(n):
	if n > frames_info.size()-1:
		return false
	frame = n
	animated_sprite.frame = n
	var offset = Vector2(float(frames_info[n].x), float(frames_info[n].y))
	animated_sprite.position = offset
	return true




func set_transforms_worldspace(frame_data):
	#this updated version of set_transforms will ignore parenting information, allowing us to load existing anims onto rigs
	var temp_transform = Transform2D(
		Vector2(frame_data.m1_a, frame_data.m1_b),  # First column
		Vector2(frame_data.m1_c, frame_data.m1_d),  # Second column
		Vector2(frame_data.m1_tx, frame_data.m1_ty) # Translation
	)
	global_transform = temp_transform  # since the scene is rendered through rendercam I don't need to do clever stuff!
	set_frame(frame_data.frame)
	#oh no i regret saying I dont need to do clever stuff...
	if false and scale.y < 0 and (rotation_degrees > 90 or rotation_degrees < -90):
		#turns out you can't -1*scaleX in transforms, so i'm gonna brute force it back into place here!
		scale.y *= -1
		scale.x *=-1
		rotation_degrees -= 180
		var offset_dir = Vector2.from_angle(-rotation)
		offset_dir = Vector2(offset_dir.y,offset_dir.x).normalized()
		position -= offset_dir * (float(frames_info[frame].y))

func propagate_baked_world(frame_data, its):
	var itsnew = its - 1
	if its < 0:
		return false
	if frame_data.has(name):
		animated_sprite.visible = true
		sprite_visible = true
		if frame_data[name].parentname != "":
			set_transforms(frame_data[name]) #we can assume that the user will set the rig correctly
		else:
			set_transforms_worldspace(frame_data[name])
	else:
		animated_sprite.visible = false #this being on the sprite allows the children to be seen (but not heard)
		sprite_visible = false
	for child in get_children():
		if child.has_method("propagate_baked_world"):
			child.propagate_baked_world(frame_data, itsnew)

func set_sprite_vis(val):
	animated_sprite.visible = val
	sprite_visible = val
	

func get_baked_transforms():
	var result = {}
	#[X: (1, 0), Y: (0, 1), O: (0.05, 0)]
	if sprite_visible:
		#i'm not sure why these are labeled as they are but they seem to work
		result["m1_tx"] = global_transform.origin.x
		result["m1_ty"] = global_transform.origin.y
		result["m1_a"] = global_transform.x.x
		result["m1_b"] = global_transform.x.y
		result["m1_c"] = global_transform.y.x
		result["m1_d"] = global_transform.y.y
		result["frame"] = frame
		result["name"] = name
		result["parentname"] = ""
	return result

func set_transforms(frame_data):
	#format is anim_data[anim_name]["frames"][current_processed_frame][element_data.name] = {name layername parentname frame depth m1_a m1_b m1_c m1_d m1_tx m1_ty}
	var temp_transform = Transform2D(
		Vector2(frame_data.m1_a, frame_data.m1_b),  # First column
		Vector2(frame_data.m1_c, frame_data.m1_d),  # Second column
		Vector2(frame_data.m1_tx, frame_data.m1_ty) # Translation
	)
	transform = temp_transform
	set_frame(frame_data.frame)
	
func set_from_kfa(frame_num, anim_name):
	var poss_keys = ["pos_x", "pos_y", "rot", "scl_x", "scl_y", "idx", "vis"]
	if GAME.keyframe_data[anim_name].has(name):
		if GAME.keyframe_data[anim_name][name].has("pos_x"):
			position.x = GAME.keyframes_master.get_kfa_data(name, "pos_x", frame_num)
		if GAME.keyframe_data[anim_name][name].has("pos_y"):
			position.y = GAME.keyframes_master.get_kfa_data(name, "pos_y", frame_num)
		if GAME.keyframe_data[anim_name][name].has("rot"):
			rotation_degrees = GAME.keyframes_master.get_kfa_data(name, "rot", frame_num)
		if GAME.keyframe_data[anim_name][name].has("skw"):
			skew = GAME.keyframes_master.get_kfa_data(name, "skw", frame_num)
		if GAME.keyframe_data[anim_name][name].has("scl_x"):
			scale.x = GAME.keyframes_master.get_kfa_data(name, "scl_x", frame_num)
		else:
			scale.x = 1 #override to default
		if GAME.keyframe_data[anim_name][name].has("scl_y"):
			scale.y = GAME.keyframes_master.get_kfa_data(name, "scl_y", frame_num)
		else:
			scale.y = 1
		if GAME.keyframe_data[anim_name][name].has("idx"):
			set_frame( int(round(GAME.keyframes_master.get_kfa_data(name, "idx", frame_num))) )
		if GAME.keyframe_data[anim_name][name].has("vis"):
			set_sprite_vis( bool(round(GAME.keyframes_master.get_kfa_data(name, "vis", frame_num))) )
