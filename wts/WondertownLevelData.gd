extends Node
class_name WondertownLevelData

"""
A container file for level data of a WTL.
Provides an interface for getting level data.
"""

var level_dict = {}
var game_node_data_array = null
var tile_node_data_array = null

func _init(level_dict):
	"""Obtains the level dict from json data."""
	self.level_dict = level_dict
	
func get_dict():
	return self.level_dict

"""
Data builders
"""

func get_game_node_data() -> Array:
	"""Returns a list of GameNodeData."""
	if not self.game_node_data_array:
		
		# Build data array.
		self.game_node_data_array = []
		
		# Add GameNodeData object by reading from dict.
		for dict_data in self.level_dict["game_nodes"]:
			self.game_node_data_array.append(GameNodeData.new(dict_data))
		
		# Return this dict.
		return self.game_node_data_array
	
	# Return cached array.
	return self.game_node_data_array

func get_tile_node_data() -> Array:
	"""Returns a list of TileNodeData."""
	if not self.tile_node_data_array:
		
		# Build data array.
		self.tile_node_data_array = []
		
		# Add TileNodeData object by reading from dict.
		for dict_data in self.level_dict["tile_nodes"]:
			self.tile_node_data_array.append(TileNodeData.new(dict_data))
		
		# Return this dict.
		return self.tile_node_data_array
	
	# Return cached array.
	return self.tile_node_data_array

"""
Various getters
"""

func get_game_nodes_of_id(id) -> Array:
	"""
	Returns an array of GameNodeData of a certain ID.
	"""
	var ret_list = []
	for game_node_data in get_game_node_data():
		if game_node_data.get_id() == id:
			ret_list.append(game_node_data)
	return ret_list

"""
Container classes
"""

class GameNodeData:
	"""
	Holds data for a game node.
	"""
	
	var data = {}
	
	func _init(data: Dictionary):
		self.data = data
		
		# Process the data after load.
		if self.data.get("positions"):
			
			# Turn all position arrays into Vector2s.
			for i in range(len(self.data["positions"])):
				var pos_array = self.data["positions"][i]
				var vec2 = Vector2(int(pos_array[0]), int(pos_array[1]))
				self.data["positions"][i] = vec2
	
	func get_id():
		var _id = self.data.get("id")
		assert(_id != null)
		return int(_id)
	
	func get_attributes():
		return self.data.get("attributes", {})
	
	func get_positions():
		return self.data.get("positions", [])

class TileNodeData:
	"""
	Holds data for a tile node.
	"""
	
	var data = {}
	
	func _init(data: Dictionary):
		self.data = data
		
		# Process the data after load.
		if self.data.get("positions"):
			
			# Turn all position arrays into Vector2s.
			for i in range(len(self.data["positions"])):
				var pos_array = self.data["positions"][i]
				var vec2 = Vector2(int(pos_array[0]), int(pos_array[1]))
				self.data["positions"][i] = vec2
	
	func get_logic():
		return int(self.data.get("logic", 0))
	
	func get_visual():
		return int(self.data.get("visual", 0))
	
	func get_positions():
		return self.data.get("positions", [])
