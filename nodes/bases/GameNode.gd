extends Spatial
class_name GameNode


"""
The base class of all gameplay elements.
All gameplay elements can extend a GameNode.
"""

# Overwrite these in extended nodes.
func get_game_node_id():
	return GameNodeIds.GameNodeID.TestBox

# Do not touch these.
# The ID of an object is a unique identifier given to a GameNode
# once it is created by the LevelGenerator. The LevelDictionary
# has a built-in dict from object id to object.
var id = null

# References to level singletons.
var _level_manager = null
var _level_dictionary = null


func initialize(set_id, level_manager_ref, level_dictionary_ref):
	"""
	Initialize the GameNode. Do not override.
	"""
	id = set_id
	_level_manager = level_manager_ref
	_level_dictionary = level_dictionary_ref
