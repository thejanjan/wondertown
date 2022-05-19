extends "res://wts/LV6Parser.gd"

"""
Reads LV5 files.
"""

func make_wld(file: File):
	"""
	Makes a WonderlandLevelData from this LV5 filestream.
	"""
	var data = WondertownLevelData.new({})
	
	"""
	Data Read
	"""
	
	# Read through the header.
	var format_name = read_file_string(file)
	var filename = read_file_string(file)
	var level_version = file.get_32()
	var level_name = read_file_string(file)
	
	# unknowns
	file.get_64()
	file.get_64()
	
	# More specific level data.
	var time_limit = file.get_32()
	var level_style = file.get_32()
	var level_background = file.get_32()
	var width = file.get_32()
	var height = file.get_32()
	
	# Load tile data.
	for x in range(width):
		for y in range(height):
			make_tile_node_from_int32(data, file.get_32(), Vector2(x, y))
	
	# Load object data.
	for x in range(width):
		for y in range(height):
			make_game_node_from_int32(data, file.get_32(), Vector2(x, y))
	
	# Load signs.
	var sign_strings = []
	for i in range(20):
		sign_strings.append(read_file_string(file))
	
	# And music variable, at the end.
	var music_id = file.get_32()
	
	"""
	Data Population
	"""
	
	data.set_header({
		"filetype": "LV6",
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
