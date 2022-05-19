extends Node


"""
A LevelDictionary.

The job of the LevelDictionary is to keep up with the full tilemap of the level.
Has accessor methods to view different tile IDs.
"""

# A complete list of all objects (GameNode).
var _all_objects = []

# The object ID dictionary stores object IDs in this pattern:
# {
# 	GameNodeIds.GameNodeID.TestBox: [instance, instance, ..., instance],
#	GameNodeIds.GameNodeID.TestPlayer: [instance],
# ...
# }
var _object_id_dict = {}

# The object ID dictionary stores object IDs in this pattern:
# {
#	1: {
#		3: [instance, instance]
# 	},
# }
# refers to the 2 instances at position (1, 3).
var _object_position_dict = {}

# The tile node dict works the same way as above.
var _tile_position_dict = {}


func _ready():
	"""
	Populate the initial dictionaries.
	"""
	for id in GameNodeIds.GameNodeID.values():
		_object_id_dict[id] = []


func add_game_node(node):
	"""
	Adds a game node to the LevelDictionary.
	"""
	_object_id_dict[node.get_game_node_id()].append(node)
	_all_objects.append(node)


func add_tile_node(tile):
	"""
	Adds a tile node to the LevelDictionary.
	"""
	var xpos = round(tile.get_xpos())
	var ypos = round(tile.get_ypos())
	
	# Get the xpos dictionary.
	if not _tile_position_dict.get(xpos):
		_tile_position_dict[xpos] = {}
	var xpos_dict = _tile_position_dict[xpos]
	
	# Set this tile to be at this ypos.
	xpos_dict[ypos] = tile


func _process(delta):
	build_position_dict()

	
func build_position_dict():
	"""
	Figures out where each object is positionally.
	"""
	# Reset our dictionary.
	_object_position_dict = {}
	
	# Iterate over all objects.
	for object in _all_objects:
		var xpos = round(object.get_xpos())
		var ypos = round(object.get_ypos())
		
		# Get the xpos dictionary.
		if not _object_position_dict.get(xpos):
			_object_position_dict[xpos] = {}
		var xpos_dict = _object_position_dict[xpos]
		
		# Init the ypos list.
		if not xpos_dict.get(ypos):
			xpos_dict[ypos] = []
		
		# Add the object to the ypost list.
		xpos_dict[ypos].append(object)
	
"""
Dictionary accessors
"""

func get_objects_at_pos(xpos, ypos):
	"""
	Returns a list of all objects at a given position.
	"""
	xpos = round(xpos)
	ypos = round(ypos)
	if not _object_position_dict.get(xpos):
		return []
	if not _object_position_dict[xpos].get(ypos):
		return []
	return _object_position_dict[xpos][ypos]
	
func get_tile_logic_at_pos(questioning_node, xpos, ypos):
	"""
	Returns the tile logic at a given position.
	"""
	xpos = round(xpos)
	ypos = round(ypos)
	
	# First, decide if we have an object at this pos with a logic override.
	for node in get_objects_at_pos(xpos, ypos):
		var override_logic = node.get_my_tile_logic(questioning_node)
		if override_logic != null:
			# First one wins
			return override_logic
	
	# If not, just grab the tile's logic.
	if not _tile_position_dict.get(xpos):
		return TileEnums.TileLogic.None
	if not _tile_position_dict[xpos].get(ypos):
		return TileEnums.TileLogic.None
	return _tile_position_dict[xpos][ypos].get_logic()

func get_tiles_of_attribute(key, value):
	"""
	Finds all nodes of a given attribute.
	"""
	var ret_list = []
	for node in _all_objects:
		if node.get_attribute(key) == value:
			ret_list.append(node)
	return ret_list
