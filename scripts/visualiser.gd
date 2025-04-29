extends Panel

var top_val = 0
var bot_val = 0
var attribute = ""
var num_frames = 0
var frames_shown_mod :float = 1.0
var num_frames_shown : int = 0
var target_name = ""
var kf_data = {}
var modi : float
var x_mod : float
var y_mod : float
var x_offset : float
var y_offset : float 
var bounds_low : float
var bounds_high : float
var bounds : float
var bounds_size : float
var bounds_center : float

func _process(delta):
	# validity checks
	if GAME.keyframes_master.current_anim and GAME.element_inspector.current_target and GAME.current_focus_attr and GAME.keyframe_data.has(GAME.current_keyframe_animname) and GAME.keyframe_data[GAME.current_keyframe_animname].has("numframes"):

		num_frames = GAME.keyframe_data[GAME.current_keyframe_animname]["numframes"]
		num_frames_shown = int(max(1,ceil(num_frames*frames_shown_mod)))
		attribute = GAME.current_focus_attr		
		if GAME.element_inspector.current_target :
			target_name = GAME.element_inspector.current_target.name
			kf_data = {}
			if GAME.keyframe_data[GAME.current_keyframe_animname].has(target_name): 
				if GAME.keyframe_data[GAME.current_keyframe_animname][target_name].has(attribute):
					kf_data = GAME.keyframe_data[GAME.current_keyframe_animname][target_name][attribute]
					if not GAME.keyframe_data[GAME.current_keyframe_animname][target_name][attribute].size() > 0:
						return false  #dont show no keys
				else:
					return 0
			else:
				return 0
		set_modifiers()
		if num_frames_shown < num_frames:
			x_offset = GAME.keyframes_master.current_kfa_frame * x_mod *-1 + size.x*0.5
		else:
			x_offset = 0
	#move the top/bot val and modi defs here
	#get center of range, add 5 to either side plus range
		queue_redraw()
	

func set_modifiers():
	modi = size.y
	y_offset = modi * 0.5 # to show pos an neg
	x_mod = size.x / num_frames_shown
	y_mod = size.y * 0.5
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
	if attribute == "pos_x" or attribute == "pos_y" or attribute == "rot":
		bounds_high = ceil(bounds_high+1)
		bounds_low = floor(bounds_low-1)
		bounds_size = bounds_high - bounds_low # the number of frames we cover
		bounds_size = ceil(bounds_size) #add some wiggle room
		bounds_high += ceil(bounds_size*0.1)
		bounds_low -= ceil(bounds_size*0.1)
		#bounds_size = max(bounds_high - bounds_low, 5)
	elif attribute == "scl_x" or attribute == "scl_y":
		bounds_high = 2
		bounds_low = 0
		bounds_size = 2
	elif attribute == "vis":
		bounds_high = 1.5
		bounds_low = -0.5
		bounds_size = bounds_high - bounds_low # the number of frames we cover
	elif attribute == "idx":
		bounds_high = GAME.element_inspector.current_target.numframes
		bounds_low = -1
		bounds_size = bounds_high - bounds_low # the number of frames we cover
	if attribute == "pos_y":
		var temp = bounds_high
		bounds_high = bounds_low
		bounds_low = temp
		
	bounds_center = ((bounds_high + bounds_low)*0.5) # the centerpoint of the bounds
	y_mod = size.y / bounds_size
	#y_mod *= 0.75 #we're making the data fit the screen here
	y_offset = (modi * 0.5) + (bounds_center * y_mod)
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


var RMB_dragging = false
var last_mouse_position = Vector2.ZERO

func _input(event):
	# Mouse in viewport coordinates.
	if event is InputEventMouseButton:
		#print("Mouse Click/Unclick at: ", event.position)
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed: 
			var key_num = int((((event.position.x - x_offset) / size.x)) * (num_frames_shown)) 
			var key_val = lerp(top_val, bot_val, (event.position.y / size.y))
			#print(event.position.y / size.y)
			if Input.is_action_pressed("add_key_timeline"):
				var blend_type = GAME.keyframe_inspector.get_blend_type()
				GAME.keyframes_master.edit_keyframe(GAME.element_inspector.current_target.name, GAME.current_focus_attr, key_val, blend_type, key_num)
				GAME.build_holder.load_kfa_frame(GAME.current_keyframe_animname, GAME.keyframes_master.current_kfa_frame)
			elif Input.is_action_pressed("remove_key_timeline"):
				var blend_type = "delete"
				GAME.keyframes_master.edit_keyframe(GAME.element_inspector.current_target.name, GAME.current_focus_attr, key_val, blend_type, key_num)
				GAME.build_holder.load_kfa_frame(GAME.current_keyframe_animname, GAME.keyframes_master.current_kfa_frame)
		elif event.button_index == MOUSE_BUTTON_RIGHT:
			if event.pressed: 
				RMB_dragging = true
				if last_mouse_position == Vector2.ZERO:
					last_mouse_position = get_viewport().get_mouse_position()
			elif not event.pressed:
				RMB_dragging = false
				last_mouse_position = Vector2.ZERO
	if event is InputEventMouseMotion and RMB_dragging:
		var current_mouse_position = get_viewport().get_mouse_position()
		var delta_position = current_mouse_position - last_mouse_position
		delta_position *= 0.001
		frames_shown_mod += delta_position.x
		frames_shown_mod = max(frames_shown_mod, 0.01)
		frames_shown_mod = min(frames_shown_mod, 1.0)
		last_mouse_position = current_mouse_position
		
func _draw():
	#drawing the Ui basics
	for i in num_frames:
		draw_line(Vector2(x_offset + i*x_mod, 0), Vector2(x_offset + i*x_mod, modi), Color.DIM_GRAY)
	for i in bounds_size:
		if attribute == "pos_y":
			i=-i
		draw_line(Vector2(0, i*y_mod), Vector2(x_mod*100, i*y_mod), Color(1,1,1,0.035))
	var playhead = float(GAME.keyframes_master.current_kfa_frame)#+ GAME.keyframes_master.playing_delta*25
	playhead *= x_mod
	if not num_frames_shown == num_frames:
		playhead = size.x*0.5
	draw_line(Vector2(playhead, 0), Vector2(playhead, modi), Color(0.5,0.5,0.5,lerp(.75,0.2,GAME.keyframes_master.playing)), x_mod)
	#playhead will be darker while playing to make it less distracting
	
	for i in num_frames+1: #draw dataline
		var key_in = x_offset + i*x_mod
		var kfdata_in = -GAME.keyframes_master.get_kfa_data(target_name, attribute, i) 
		kfdata_in *= y_mod
		kfdata_in += y_offset #draw in middle of framge
		
		var key_out = x_offset + (i+1)*x_mod
		var kfdata_out = -GAME.keyframes_master.get_kfa_data(target_name, attribute, i+1) 
		kfdata_out *= y_mod
		kfdata_out += y_offset
		
		draw_line(Vector2(key_in, kfdata_in), Vector2(key_out, kfdata_out), Color.WHITE_SMOKE, 0.5, true)
		
		if attribute == "idx":
			kfdata_in = round(-GAME.keyframes_master.get_kfa_data(target_name, attribute, i) )
			kfdata_in *= y_mod
			kfdata_in += y_offset
			draw_line(Vector2(key_in, kfdata_in), Vector2(key_out, kfdata_in), Color(0.5,.5,.5,.75), 1, true)
			#drawing the stepped keys in!
		if kf_data.has(int(i)):
			draw_line(Vector2(key_in, (kfdata_in) + 2.5 ), Vector2(key_in, (kfdata_in) - 2.5 ), Color.WHITE_SMOKE, 5)
			#drawing a dot if this is a keyframe!
