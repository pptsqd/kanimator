extends Panel

func _process(delta):
	queue_redraw()

func _draw():
	if GAME.keyframes_master.current_anim and GAME.keyframe_data[GAME.current_keyframe_animname]["numframes"]:
		var numframes = GAME.keyframe_data[GAME.current_keyframe_animname]["numframes"]
		var modi = size.y
		var y_offset = modi * 0.5 # to show pos an neg
		var x_mod = size.x / numframes
		var y_mod = size.y * 0.05
		var attribute = "rot"
		var bounds = 1
		
		#drawing the Ui basics
		for i in numframes:
			draw_line(Vector2(i*x_mod, 0), Vector2(i*x_mod, modi), Color.DIM_GRAY)
		var playhead = float(GAME.keyframes_master.current_kfa_frame)#+ GAME.keyframes_master.playing_delta*25
		draw_line(Vector2(playhead*x_mod, 0), Vector2(playhead*x_mod, modi), Color(0.5,0.5,0.5,lerp(.75,0.2,GAME.keyframes_master.playing)), x_mod)
		#playhead will be darker while playing to make it less distracting
		
		#sort and draw the data
		if GAME.element_inspector.current_target and GAME.current_keyframe_animname and GAME.keyframe_data.has(GAME.current_keyframe_animname):
			var target_name = GAME.element_inspector.current_target.name
			var kf_data = {}
			if GAME.keyframe_data[GAME.current_keyframe_animname].has(target_name): 
				if GAME.keyframe_data[GAME.current_keyframe_animname][target_name].has(attribute):
					kf_data = GAME.keyframe_data[GAME.current_keyframe_animname][target_name][attribute]
				else:
					return 0
			else:
				return 0
			#now we know we have data we can draw it
			for frame in kf_data:
				if abs(kf_data[frame].value) > bounds:
					bounds = abs(kf_data[frame].value)
					y_mod = size.y / (bounds+1)
					y_mod *= 0.5 #we're making the data fit the screen here
			for i in numframes: #draw dataline
				var key_in = i*x_mod
				var kfdata_in = GAME.keyframes_master.get_kfa_data(target_name, attribute, i) 
				kfdata_in *= y_mod
				kfdata_in += y_offset #draw in middle of framge
				var key_out = (i+1)*x_mod
				var kfdata_out = GAME.keyframes_master.get_kfa_data(target_name, attribute, i+1) 
				kfdata_out *= y_mod
				kfdata_out += y_offset
				draw_line(Vector2(key_in, kfdata_in), Vector2(key_out, kfdata_out), Color.WHITE_SMOKE, 0.5, true)
				if kf_data.has(i):
					draw_line(Vector2(key_in, (kfdata_in) + 2.5 ), Vector2(key_in, (kfdata_in) - 2.5 ), Color.WHITE_SMOKE, 5)
					#drawing a dot if this is a keyframe!
	
