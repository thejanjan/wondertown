extends Node

"""
The LevelGenerator scene is a node that is capable of taking
a child level node, parsing its tileset data into a level in 3D space.

It will find a LevelTileset node, and then interface with it
in order create an entire level instance.
"""

const WSWGUI = preload("res://nodes/bases/WSWGUI.tscn")
const GeneralTile = preload("res://nodes/tile_nodes/GeneralTile.tscn")

const WondertownLevelData = preload("res://wts/WondertownLevelData.gd")
const LevelTileset = preload("res://level/LevelTileset.gd")
var _level_data = null
var _level_manager = null
var _level_dictionary = null
var _level_io = null
var _current_id = 1

var level_built = false

signal make_level_data

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
	if (data is WondertownLevelData):
		rpc("set_level_data", data.get_dict())

remotesync func set_level_data(data_dict):
	self._level_data = WondertownLevelData.new(data_dict)
	emit_signal("make_level_data", self._level_data)

func get_level_dictionary():
	"""
	Returns our level dictionary.
	"""
	return _level_dictionary

func get_data():
	return self._level_data

"""
Level Builder
"""

func build_level():
	"""
	Builds a level from the currently set tileset.
	"""
	if level_built:
		return
	level_built = true
	assert(self._level_data)
	
	# Build game nodes and tile data.
	_build_game_nodes()
	_build_tile_data(self._level_data)
	
	# Add game GUI.
	var gui = WSWGUI.instance()
	add_child(gui)
	gui.set_level_dict(WSWGUI)

func _build_game_nodes():
	"""
	Builds all of the game node instances.
	"""
	# Build each object in this list.
	for game_node_data in self._level_data.get_game_node_data():
		# Get the properties of this game node.
		var id = game_node_data.get_id()
		var attr_dict = game_node_data.get_attributes()
		
		# Build an instance of this game node at each position.
		for vec2 in game_node_data.get_positions():
			# Create the object node.
			var object := GameNodeIds.make_instance(id) as GameNode
			self.add_child(object)
			object.set_gamenode_pos(vec2.x, vec2.y, true)
			
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
	# Build each tile in this list.
	for tile_node_data in self._level_data.get_tile_node_data():
		# Get the properties of this tile node.
		var logic = tile_node_data.get_logic()
		var visual = tile_node_data.get_visual()
		
		# Build an instance of this tile node at each position.
		for vec2 in tile_node_data.get_positions():
			# Create the tile node.
			var tile = GeneralTile.instance()
			tile.set_tilenode_pos(vec2.x, vec2.y, true)
			self.add_child(tile)
			
			# Set the properties of this node.
			tile.initialize(logic, visual, tile_node_data)
			
			# Tell the dictionary about this tile.
			_level_dictionary.add_tile_node(tile)
