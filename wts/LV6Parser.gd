extends Node

const WondertownLevelData = preload("WondertownLevelData.gd")
var custom_assets = ['houses', 'models', 'textures', 'background']
var cached_sign_load = {}

var LevelStyleData = {
	0: {
		'floor_tex': ["woodfloor1", "woodfloor2", "woodfloor3", "woodfloor4"],
		'wall_tex': [
			'Woodwalltop1', '', 'woodwallside1a', 'woodwallside1a', 'woodwallside1a', 'woodwallside1a',
		],
		'fake_wall_tex': [
			'Woodwalltop1', '', 'woodwallside3a', 'woodwallside3a', 'woodwallside3a', 'woodwallside3a',
		],
	},
	1: {
		'floor_tex': ["woodfloor1", "woodfloor2", "woodfloor3", "woodfloor4"],
		'wall_tex': [
			'Woodwalltop1', '', 'woodwallside1a', 'woodwallside1a', 'woodwallside1a', 'woodwallside1a',
		],
		'fake_wall_tex': [
			'Woodwalltop1', '', 'woodwallside3a', 'woodwallside3a', 'woodwallside3a', 'woodwallside3a',
		],
	},
	2: {
		'floor_tex': ["woodfloor1", "woodfloor2", "woodfloor3", "woodfloor4"],
		'wall_tex': [
			'Woodwalltop1', '', 'woodwallside1a', 'woodwallside1a', 'woodwallside1a', 'woodwallside1a',
		],
		'fake_wall_tex': [
			'Woodwalltop1', '', 'woodwallside3a', 'woodwallside3a', 'woodwallside3a', 'woodwallside3a',
		],
	},
	3: {
		'floor_tex': ["woodfloor1", "woodfloor2", "woodfloor3", "woodfloor4"],
		'wall_tex': [
			'Woodwalltop1', '', 'woodwallside1a', 'woodwallside1a', 'woodwallside1a', 'woodwallside1a',
		],
		'fake_wall_tex': [
			'Woodwalltop1', '', 'woodwallside3a', 'woodwallside3a', 'woodwallside3a', 'woodwallside3a',
		],
	},
	4: {
		'floor_tex': ["woodfloor1", "woodfloor2", "woodfloor3", "woodfloor4"],
		'wall_tex': [
			'Woodwalltop1', '', 'woodwallside1a', 'woodwallside1a', 'woodwallside1a', 'woodwallside1a',
		],
		'fake_wall_tex': [
			'Woodwalltop1', '', 'woodwallside3a', 'woodwallside3a', 'woodwallside3a', 'woodwallside3a',
		],
	},
	5: {
		'floor_tex': ["woodfloor1", "woodfloor2", "woodfloor3", "woodfloor4"],
		'wall_tex': [
			'Woodwalltop1', '', 'woodwallside1a', 'woodwallside1a', 'woodwallside1a', 'woodwallside1a',
		],
		'fake_wall_tex': [
			'Woodwalltop1', '', 'woodwallside3a', 'woodwallside3a', 'woodwallside3a', 'woodwallside3a',
		],
	},
	6: {
		'floor_tex': ["woodfloor1", "woodfloor2", "woodfloor3", "woodfloor4"],
		'wall_tex': [
			'Woodwalltop1', '', 'woodwallside1a', 'woodwallside1a', 'woodwallside1a', 'woodwallside1a',
		],
		'fake_wall_tex': [
			'Woodwalltop1', '', 'woodwallside3a', 'woodwallside3a', 'woodwallside3a', 'woodwallside3a',
		],
	},
	7: {
		'floor_tex': ["woodfloor1", "woodfloor2", "woodfloor3", "woodfloor4"],
		'wall_tex': [
			'Woodwalltop1', '', 'woodwallside1a', 'woodwallside1a', 'woodwallside1a', 'woodwallside1a',
		],
		'fake_wall_tex': [
			'Woodwalltop1', '', 'woodwallside3a', 'woodwallside3a', 'woodwallside3a', 'woodwallside3a',
		],
	},
	8: {
		'floor_tex': ["woodfloor1", "woodfloor2", "woodfloor3", "woodfloor4"],
		'wall_tex': [
			'Woodwalltop1', '', 'woodwallside1a', 'woodwallside1a', 'woodwallside1a', 'woodwallside1a',
		],
		'fake_wall_tex': [
			'Woodwalltop1', '', 'woodwallside3a', 'woodwallside3a', 'woodwallside3a', 'woodwallside3a',
		],
	},
	9: {
		'floor_tex': ["woodfloor1", "woodfloor2", "woodfloor3", "woodfloor4"],
		'wall_tex': [
			'Woodwalltop1', '', 'woodwallside1a', 'woodwallside1a', 'woodwallside1a', 'woodwallside1a',
		],
		'fake_wall_tex': [
			'Woodwalltop1', '', 'woodwallside3a', 'woodwallside3a', 'woodwallside3a', 'woodwallside3a',
		],
	},
}
var level_style = 2

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
	level_style = file.get_32()
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
		### Coins! ###
		5:
			data.set_id(int(GameNodeIds.GameNodeID.WSWRainbowCoin))
		8:
			data.set_id(int(GameNodeIds.GameNodeID.WSWBonusCoin))
		### Exit ###
		6:
			data.set_id(int(GameNodeIds.GameNodeID.WSWExit))
		### Boxes ###
		9:  # Wooden Box
			data.set_id(int(GameNodeIds.GameNodeID.WoodenBox))
		### Sign ###
		['Sign', ..]:
			data.set_attribute("Dialogue", int32[1])
			data.set_id(int(GameNodeIds.GameNodeID.Sign))
		### Toll Gate ###
		['TollGate', ..]:
			var direction = int32[1]
			data.set_attribute("Direction", direction)
			data.set_id(int(GameNodeIds.GameNodeID.WSWCoinGate))
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
		### Floors ###
		100, 101, 102, 103:
			data.set_properties(0, 0)
			data.set_tex([LevelStyleData[level_style]['floor_tex'][int32 - 100], '', '', '', '', ''])
		### Things that can spawn on floors ###
		1000, 1001:
			data.set_properties(0, 0)
			data.set_tex([LevelStyleData[level_style]['floor_tex'][0], '', '', '', '', ''])
			match int32:
				1000, 1001:
					make_game_node_from_int32(wld, ["TollGate", int32], pos)
		### Walls ###
		200, 201, 202, 203:
			data.set_properties(1, 1)
			data.set_tex(LevelStyleData[level_style]['wall_tex'])
		1500, 1501, 1502:
			data.set_properties(1, 1)
			data.set_tex(LevelStyleData[level_style]['fake_wall_tex'])
		### Signs ###
		1300, 1301, 1302, 1303, 1304, 1305, 1306, 1307, 1308, 1309, 1310, 1311, 1312, 1313, 1314, 1315, 1316, 1317, 1318, 1319, 1310:
			# Implies normal ground
			data.set_properties(0, 0)
			data.set_tex([LevelStyleData[level_style]['floor_tex'][0], '', '', '', '', ''])
			# Also, add sign gamenode
			cached_sign_load[int32 - 1300] = pos
		### Undefined ###
		_:
			return
	
	# Add this data into the wld.
	wld.add_tile_node(data, pos)
