extends Control



func export_KAB(file_path: String) -> void:
	
	var file := FileAccess.open(file_path, FileAccess.WRITE)
	var incremental = 0
	file.store_line('<Anims>')
	var processed_sprites = GAME.build_holder.build_nodes
	for ksprite in processed_sprites: #do this for each 
		
		file.store_line('\t<anim name="anim" root="character" numframes="%d" framerate="30">' % [ #most of these vars are set
			ksprite.numframes,
		])
		var layername = str(floor(randf()*1000000000)) #idk if there's signifigance to the layernames so im printing randoms
		for frame in ksprite.numframes:
			file.store_line('\t\t<frame idx="' + str(incremental) + '" w="0" h="0" x="0" y="0">')
			incremental += 1  #idk if the idx all have to be different but i figure matching is best
			
			#for element in processed_data["frames"][frame]: #some of the builds have multi elements but I think we can get away with this
			var element_data = ksprite["frames_info"][frame]
			print(element_data)
			#sprite_data = {"texture" = texture, "w" = frame_data.w, "h" = frame_data.h, "x" = frame_data.x, "y" = frame_data.y}
			file.store_line('\t\t\t<element name="%s" layername="%s" parentname="" frame="%s" depth="0" m1_a="1" m1_b="0" m1_c="0" m1_d="1" m1_tx="%s" m1_ty="%s" %s/>' % [
				ksprite.name,
				layername,
				str(frame), #doesn't always seem to be the case but an educated guess?
				str(0),
				str(0),
				' m0_a="1" m0_b="0" m0_c="0" m0_d="1" m0_tx="0" m0_ty="0" c_01="0" c_02="0" c_03="0" c_10="0" c_12="0" c_13="0" c_20="0" c_21="0" c_23="0" c_30="0" c_31="0" c_32="0" c_40="0" c_41="0" c_42="0" c_43="0" c_44="1" c_00="1" c_11="1" c_22="1" c_33="1" c_04="0" c_14="0" c_24="0" c_34="0"'
			])
			file.store_line('\t\t</frame>')

		file.store_line('</anim>')
	file.store_line('</Anims>')

	file.close()

	print("Animation data exported successfully to:", file_path)
