extends "res://wts/LV6Parser.gd"

"""
Reads LEV files.
"""

func make_wld(file: File):
	"""
	Makes a WonderlandLevelData from this LEV filestream.
	"""
	var data = WondertownLevelData.new({})
	
	"""
	Data Read
	"""
	
	# Read through the header.
	var format_name = read_file_string(file)
	var filename = read_file_string(file)
	var level_name = read_file_string(file)
	
	# More specific level data.
	var time_limit = file.get_32()
	var level_style = file.get_32()
	var level_background = file.get_32()
	var width = file.get_32()
	var height = file.get_32()
	
	# Load tile data.
	for y in range(height):
		for x in range(width):
			make_tile_node_from_int32(data, file.get_32(), Vector2(x, y))
	
	# Load object data.
	for y in range(height):
		for x in range(width):
			make_game_node_from_int32(data, file.get_32(), Vector2(x, y))
	
	# Load signs.
	var sign_strings = []
	for i in range(20):
		sign_strings.append(read_file_string(file))
		
		# Do we need to load a sign for this?
		if i in cached_sign_load:
			make_game_node_from_int32(data, ['Sign', sign_strings[i]], cached_sign_load[i])
	
	# And music variable, at the end.
	var music_id = file.get_32()
	
	"""
	Data Population
	"""
	
	data.set_header({
		"filetype": "LEV",
		"level_name": level_name,
		"time": time_limit,
		"style": level_style,
		"background": level_background,
		"level_size": [width, height],
		"music": music_id
	})
	
	# Our data is populated, lets goo
	data.update_dict()
	return data

"""
Game Node Read
"""

func make_game_node_from_int32(wld, int32, pos):
	# Makes GameNodeData and asks to put it
	# into the data dictionary.
	var data = WondertownLevelData.GameNodeData.new({})
	
	# The big data populator
	match int32:
		### Player Characters ###
		1, 2:
			data.set_attribute("Player", int32)
			data.set_attribute("PlayerOwned", 1)
			data.set_id(int(GameNodeIds.GameNodeID.TestPlayer))
			
			# for test, spawn a loof here too
			if int32 == 1:
				make_game_node_from_int32(wld, 2, pos)
			
		3:  # Wood Box
			data.set_id(int(GameNodeIds.GameNodeID.WoodenBox))
		4:  # Steel Box
			return
		5:  # Exit
			data.set_id(int(GameNodeIds.GameNodeID.WSWExit))
		6:  # Rainbow Coin
			return
		7:  # Coily
			return
		8, 9, 10, 11, 12, 13, 14, 15:
			# Various ZBot flavors.
			return
		16, 17, 18, 19, 20, 21, 22, 23:
			# Various Kaboom flavors.
			return
		25: # Bonus Coin
			return
		26: # FISH
			return
		27: # Snow weather
			return
		28: # Pillar
			return
		29: # Fat spike
			return
		30: # Thin spike
			return
		### Undefined ###
		_:
			# Maybe our parent has something.
			.make_game_node_from_int32(wld, int32, pos)
			return
	
	# Add this data into the wld.
	wld.add_game_node(data, pos)
