extends Node

"""
The LevelGenerator scene is a node that is capable of taking
a child level node, parsing its tileset data into a level in 3D space.

It will find a LevelTileset node, and then interface with it
in order create an entire level instance.
"""

const LevelTileset = preload("res://level/LevelTileset.gd")
var _level_data = null
var _level_manager = null
var _level_dictionary = null
var _level_io = null
var _current_id = 1


func _ready():
	_level_dictionary = preload("res://level/LevelDictionary.tscn").instance()
	add_child(_level_dictionary)
	_level_io = preload("res://wts/WondertownLevelIO.tscn").instance()
	add_child(_level_io)
	_level_manager = get_parent()

func add_level(filepath):
	"""
	Adds a level node to the LevelGenerator.
	"""
	# Try to read the data.
	var data = _level_io.load_file(filepath)
	
	# Hopefully our data read was a success.
	if (data is Dictionary):
		self._level_data = data

func get_level_dictionary():
	"""
	Returns our level dictionary.
	"""
	return _level_dictionary

"""
Level Builder
"""

func build_level():
	"""
	Builds a level from the currently set tileset.
	"""
	assert(self._level_data)
	
	# Build game nodes and tile data.
	_build_game_nodes(self._level_data)
	_build_tile_data(self._level_data)

func _build_game_nodes(level_data):
	"""
	Builds all of the game node instances.
	"""
	var game_node_list = level_data["game_nodes"]
	
	# Build each object in this list.
	for game_node_data in game_node_list:
		# Get the properties of this game node.
		var id = int(game_node_data["id"])
		var positions_list = game_node_data["positions"]
		var attr_dict = game_node_data["attributes"]
		
		# Build an instance of this game node at each position.
		for position in positions_list:
			# Get the position for this object.
			var x = int(position[0])
			var y = int(position[1])
			
			# Create the object node.
			var object := GameNodeIds.make_instance(id) as GameNode
			object.set_gamenode_pos(x, y, true)
			self.add_child(object)
			
			# Set the properties of this node.
			object.update_attribute_dict(attr_dict)
			object.initialize(_current_id, _level_manager, _level_dictionary)
			_current_id += 1
			
			# Tell the dictionary about this object.
			_level_dictionary.add_game_node(object)
	
func _build_tile_data(level_data):
	"""
	Builds all of the tile node instances.
	Still pretty WIP as the TileNode system is not fully robust.
	(The hooks into the GameNodeIds system will be removed over time.)
	"""
	var tile_node_list = level_data["tile_nodes"]
	
	# Build each tile in this list.
	for tile_node_data in tile_node_list:
		# Get the properties of this tile node.
		var logic = int(tile_node_data["logic"])
		var visual = int(tile_node_data["visual"])
		var positions_list = tile_node_data["positions"]
		
		# Build an instance of this tile node at each position.
		for position in positions_list:
			# Get the position for this tile.
			var x = int(position[0])
			var y = int(position[1])
			
			# Create the tile node.
			var tile := GameNodeIds.make_instance(0) as TileNode
			tile.set_tilenode_pos(x, y, true)
			self.add_child(tile)
			
			# Set the properties of this node.
			tile.initialize(logic, visual)
			
			# Tell the dictionary about this tile.
			_level_dictionary.add_tile_node(tile)
