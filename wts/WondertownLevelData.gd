extends Node
class_name WondertownLevelData

"""
A container file for level data of a WTL.
Provides an interface for getting level data.
"""

var level_dict = {}
var game_node_data_array = []
var tile_node_data_array = []

func _init(level_dict):
	"""Obtains the level dict from json data."""
	self.level_dict = level_dict
	
	# Set basic params of the level dict.
	if not self.level_dict.get('header'):
		self.level_dict['header'] = {}
	if not self.level_dict.get('game_nodes'):
		self.level_dict['game_nodes'] = []
	if not self.level_dict.get('tile_nodes'):
		self.level_dict['tile_nodes'] = []
	
func get_dict():
	return self.level_dict
	
func update_dict():
	"""Updates the dict to array information."""
	self.level_dict['game_nodes'] = []
	for gnd in self.game_node_data_array:
		self.level_dict['game_nodes'].append(gnd.get_dict())
	self.level_dict['tile_nodes'] = []
	for tnd in self.tile_node_data_array:
		self.level_dict['tile_nodes'].append(tnd.get_dict())

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

func get_tiles_of_attribute(key, value):
	var ret_list = []
	for game_node_data in get_game_node_data():
		if game_node_data.get_attributes().get("PlayerOwned") == value:
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
		else:
			self.data["positions"] = []
		if self.data.get('attributes', null) == null:
			self.data["attributes"] = {}
		if self.data.get('id', null) == null:
			self.data['id'] = -1
	
	func get_id():
		var _id = self.data.get("id")
		assert(_id != null)
		return int(_id)
	
	func get_attributes():
		return self.data.get("attributes", {})
	
	func get_positions():
		return self.data.get("positions", [])
	
	func get_dict():
		var dict = {}
		dict['attributes'] = get_attributes()
		dict['id'] = get_id()
		dict['positions'] = []
		for position in get_positions():
			dict['positions'].append([position.x, position.y])
		return dict
	
	func is_eq_to(other: GameNodeData):
		return (
			(self.get_id() == other.get_id())
			and (self.get_attributes() == other.get_attributes())
		)
	
	"""Setters"""
	
	func set_id(id):
		self.data['id'] = id
	
	func set_attribute(key, value):
		self.data['attributes'][key] = value
		
	func add_position(vec2):
		self.data['positions'].append(vec2)

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
		else:
			self.data["positions"] = []
		if self.data.get('tex', null) == null:
			self.data["tex"] = [0, 0, 0, 0, 0, 0]
		if self.data.get('logic', null) == null:
			self.data['logic'] = -1
		if self.data.get('visual', null) == null:
			self.data['visual'] = -1
		
	func get_logic():
		return int(self.data.get("logic", 0))
	
	func get_visual():
		return int(self.data.get("visual", 0))
	
	func get_positions():
		return self.data.get("positions", [])
	
	func get_tex():
		return self.data.get("tex", [0, 0, 0, 0, 0, 0])
	
	func get_dict():
		var dict = {}
		dict['logic'] = get_logic()
		dict['visual'] = get_visual()
		dict['tex'] = get_tex()
		dict['positions'] = []
		for position in get_positions():
			dict['positions'].append([position.x, position.y])
		return dict
	
	func is_eq_to(other: TileNodeData):
		return (
			(self.get_logic() == other.get_logic())
			and (self.get_visual() == other.get_visual())
			and (self.get_tex() == other.get_tex())
		)
		
	"""Setter methods"""
		
	func set_properties(logic, visual):
		self.data['logic'] = logic
		self.data['visual'] = visual
	
	func set_tex(l):
		self.data['tex'] = l
	
	func add_position(vec2):
		self.data['positions'].append(vec2)

"""
External setters
"""

func set_header(dict):
	level_dict['header'] = dict
	
func add_game_node(game_node_data, pos):
	if game_node_data.get_id() == -1:
		return
	
	# Find if there's any GND that exists already.
	for existing_gnd in self.game_node_data_array:
		if existing_gnd.is_eq_to(game_node_data):
			# Add this gamenode's position to the existing gnd.
			existing_gnd.add_position(pos)
			return
	
	# New gamenode data!
	game_node_data.add_position(pos)
	self.game_node_data_array.append(game_node_data)
	
func add_tile_node(tile_node_data, pos):
	if tile_node_data.get_logic() == -1:
		return
	if tile_node_data.get_visual() == -1:
		return
	
	# Find if there's any GND that exists already.
	for existing_tnd in self.tile_node_data_array:
		if existing_tnd.is_eq_to(tile_node_data):
			# Add this tilenode's position to the existing gnd.
			existing_tnd.add_position(pos)
			return
	
	# New tilenode data!
	tile_node_data.add_position(pos)
	self.tile_node_data_array.append(tile_node_data)
