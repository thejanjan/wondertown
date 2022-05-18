extends Node

const WondertownLevelData = preload("WondertownLevelData.gd")
var custom_assets = ['houses', 'models', 'textures', 'background']

"""
Reads LV6 files.
"""

func make_wld(file: File):
	"""
	Makes a WonderlandLevelData from this LV6 filestream.
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
	
	# Custom asset reading.
	var loaded_asset_data = {}
	for ca in custom_assets:
		var flag = file.get_32()
		var ca_name = read_file_string(file)
		loaded_asset_data[ca] = [flag, ca_name]
	
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

func read_file_string(file: File):
	# Get the length of the file string.
	var string_length = file.get_32()
	var byte_array = PoolByteArray()
	for i in range(string_length):
		byte_array.append(file.get_8())
	return byte_array.get_string_from_utf8()

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
		1, 2, 3, 4:
			data.set_attribute("Player", int32)
			data.set_attribute("PlayerOwned", 1)
			data.set_id(int(GameNodeIds.GameNodeID.TestPlayer))
		### Undefined ###
		_:
			return
	
	# Add this data into the wld.
	wld.add_game_node(data, pos)

"""
Tile Node Read
"""

func make_tile_node_from_int32(wld, int32, pos):
	# Makes TileNodeData and asks to put it
	# into the data dictionary.
	var data = WondertownLevelData.TileNodeData.new({})
	
	# The big data populator
	match int32:
		### Player Characters ###
		100, 101, 102, 103:
			data.set_properties(0, 0)
			data.set_tex(["grass_top", "dirt", "grass_side", "grass_side", "grass_side", "grass_side"])
		### Undefined ###
		_:
			return
	
	# Add this data into the wld.
	wld.add_tile_node(data, pos)
