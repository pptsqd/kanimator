extends Panel

var top_val = 0
var bot_val = 0
var attribute = ""
var num_frames = 0
var target_name = ""
var kf_data = {}

func _process(delta):
	#move the valid checks here
	if GAME.keyframes_master.current_anim and GAME.keyframe_data.has(GAME.current_keyframe_animname) and GAME.keyframe_data[GAME.current_keyframe_animname].has("numframes"):
		num_frames = GAME.keyframe_data[GAME.current_keyframe_animname]["numframes"]
		attribute = GAME.current_focus_attr
		if GAME.element_inspector.current_target:
			target_name = GAME.element_inspector.current_target.name
			kf_data = {}
			if GAME.keyframe_data[GAME.current_keyframe_animname].has(target_name): 
				if GAME.keyframe_data[GAME.current_keyframe_animname][target_name].has(attribute):
					kf_data = GAME.keyframe_data[GAME.current_keyframe_animname][target_name][attribute]
				else:
					return 0
			else:
				return 0
	#move the top/bot val and modi defs here
	#get center of range, add 5 to either side plus range
		queue_redraw()
	
	
func _input(event):
	var modi = size.y
	var y_offset = modi * 0.5 # to show pos an neg
	var x_mod = size.x / num_frames
	var y_mod = size.y * 0.5
	
	# Mouse in viewport coordinates.
	if event is InputEventMouseButton:
		#print("Mouse Click/Unclick at: ", event.position)
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed: 
			var key_num = int((event.position.x / size.x) * num_frames) 
			var key_val = lerp(top_val, bot_val, (event.position.y / size.y))
			print(event.position.y / size.y)
			if Input.is_action_pressed("add_key_timeline"):
				var blend_type = GAME.keyframe_inspector.get_blend_type()
				GAME.keyframes_master.edit_keyframe(GAME.element_inspector.current_target.name, GAME.current_focus_attr, key_val, blend_type, key_num)
		
func _draw():
	var modi = size.y
	var y_offset = modi * 0.5 # to show pos an neg
	var x_mod = size.x / num_frames
	var y_mod = size.y * 0.5
	
	
	#drawing the Ui basics
	for i in num_frames:
		draw_line(Vector2(i*x_mod, 0), Vector2(i*x_mod, modi), Color.DIM_GRAY)
	var playhead = float(GAME.keyframes_master.current_kfa_frame)#+ GAME.keyframes_master.playing_delta*25
	draw_line(Vector2(playhead*x_mod, 0), Vector2(playhead*x_mod, modi), Color(0.5,0.5,0.5,lerp(.75,0.2,GAME.keyframes_master.playing)), x_mod)
	#playhead will be darker while playing to make it less distracting

	var bounds_low : float
	var bounds_high : float
	var bounds_set = false
	for frame in kf_data:
		if not bounds_set:
			bounds_set = true
			bounds_low = (kf_data[frame].value)
			bounds_high = (kf_data[frame].value)
		if (kf_data[frame].value) > bounds_high:
			bounds_high = (kf_data[frame].value)
		if (kf_data[frame].value) < bounds_low:
			bounds_low = (kf_data[frame].value)
	var bounds = bounds_high - bounds_low
	y_mod = size.y / (bounds+0.10)
	y_mod *= 0.75 #we're making the data fit the screen here
	y_offset = y_offset + ( (((bounds_high+bounds_low)*0.5)) * y_mod)
	if attribute == "vis":
		y_mod = size.y * 0.5
		y_offset = size.y * 0.75
		draw_line(Vector2(0, y_mod), Vector2(size.x, y_mod),  Color.DIM_GRAY) 
		# attr is binary so we can make this way easier to read; if val is above center-line it's on
	elif attribute == "pos_y":
		#gross but i'm manually flipping all pos_y values for UX reasons
		y_mod = y_mod*-1
		y_offset = (modi * 0.5) + ( (((bounds_high+bounds_low)*0.5)) * y_mod)
	
	top_val = bounds_high
	bot_val = bounds_low
	
	for i in num_frames+1: #draw dataline
		var key_in = i*x_mod
		var kfdata_in = -GAME.keyframes_master.get_kfa_data(target_name, attribute, i) 
		kfdata_in *= y_mod
		kfdata_in += y_offset #draw in middle of framge
		
		var key_out = (i+1)*x_mod
		var kfdata_out = -GAME.keyframes_master.get_kfa_data(target_name, attribute, i+1) 
		kfdata_out *= y_mod
		kfdata_out += y_offset
		
		draw_line(Vector2(key_in, kfdata_in), Vector2(key_out, kfdata_out), Color.WHITE_SMOKE, 0.5, true)
		
		if attribute == "idx":
			kfdata_in = round(-GAME.keyframes_master.get_kfa_data(target_name, attribute, i) )
			kfdata_in *= y_mod
			kfdata_in += y_offset
			draw_line(Vector2(key_in, kfdata_in), Vector2(key_out, kfdata_in), Color(0.5,.5,.5,.5), 0.5, true)
			#drawing the stepped keys in!
		if kf_data.has(int(i)):
			draw_line(Vector2(key_in, (kfdata_in) + 2.5 ), Vector2(key_in, (kfdata_in) - 2.5 ), Color.WHITE_SMOKE, 5)
			#drawing a dot if this is a keyframe!
