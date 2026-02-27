extends Node

#code for generating builds, not yet added to main window

#<Build name="twitchportrait.fla">
  #<Symbol name="left_eye">
	#<Frame framenum="0" duration="1" image="twitch_eye" w="51" h="86" x="0" y="0" />
  #</Symbol>
  #<Symbol name="body">
	#<Frame framenum="0" duration="1" image="twitch_body" w="209" h="242" x="0" y="0" />
	#<Frame framenum="1" duration="1" image="Twitch_Chat" w="209" h="242" x="0" y="0" />
  #</Symbol>
#</Build>

func generate_build_xml(folder_path: String):
	var folders = folder_path.split("\\")
	var folder_name = folders[folders.size() - 1]
	var xml_output = '<Build name="%s">\n' % folder_name  #I dont think we actually need a name but we will do it anyways
	
	# select files
	var files = DirAccess.get_files_at(folder_path)
	if files.is_empty():
		print("No files found in: ", folder_path)
		return
	
	# regex to match "NAME-#(frame)"
	var regex = RegEx.new()
	regex.compile("^(.+)-(\\d+)\\.[a-zA-Z]+$")
	
	var symbols = {} 
	
	# go thru the folder and analyse the images to define frames
	for file_name in files:
		if file_name.right(4) == ".png" :  #only load pngs
			# find and load image to get its dimensions
			var full_path = folder_path.path_join(file_name)
			var img = Image.load_from_file(full_path)
			var width = 0
			var height = 0
			if img:
				width = img.get_width()
				height = img.get_height()
			
			var result = regex.search(file_name)  #check if we have a -0 suffix
			var symbol_name = ""
			var frame_num = 0
			var image_id = file_name.get_basename()
			
			if result:
				symbol_name = result.get_string(1)
				frame_num = result.get_string(2).to_int()
			else:  #if theres no num we assume its a single frame
				symbol_name = file_name.get_basename()
				frame_num = 0
				
			if not symbols.has(symbol_name):
				symbols[symbol_name] = []
			
			symbols[symbol_name].append({"num": frame_num, "img": image_id,"w": width,"h": height})

	# build the symbols from our frame data
	for s_name in symbols.keys():
		xml_output += "<Symbol name=\"%s\">\n" % s_name
		
		var frames = symbols[s_name] 
		frames.sort_custom(func(a, b): return a["num"] < b["num"]) #sorting in case we have them in wrong order somehow
		
		for frame in frames:
			xml_output += '  <Frame framenum="%d" duration="1" image="%s" w="%d" h="%d" x="0" y="0"/>\n' % \
				[frame["num"], frame["img"], frame["w"], frame["h"]]
				
		xml_output += "</Symbol>\n"

	xml_output += "</Build>"

	# export!!!
	var save_path = folder_path + "build.xml"  #we can assume we want it in the same place as the images
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_string(xml_output)
	print("XML exported to: ", ProjectSettings.globalize_path(save_path))


func _on_file_dialog_dir_selected(dir):
	generate_build_xml(dir)
