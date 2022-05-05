extends Node


"""
A LevelDictionary.

The job of the LevelDictionary is to keep up with the full tilemap of the level.
Has accessor methods to view different tile IDs.
"""

# The object ID dictionary stores object IDs in this pattern:
# {
# 	GameNodeIds.GameNodeID.TestBox: [instance, instance, ..., instance],
#	GameNodeIds.GameNodeID.TestPlayer: [instance],
# ...
# }
var _object_id_dict = {}


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
	# TODO - refactor function call to take the GameNodeID from the game node.
	_object_id_dict[node.get_game_node_id()].append(node)
