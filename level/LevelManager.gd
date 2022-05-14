extends Node


"""
The LevelManager is the highest-order node for running and creating a level.
It is the interface for any object to interact with whenever a level is to be made.

A Level is a high-order scene node that generates an entire level within it.
"""
const Barrier = preload("res://network/util/Barrier.gd")

# Create the helper nodes for the LevelManager.
var _level_generator = preload("res://level/LevelGenerator.tscn").instance()
var _level = null
var _level_dictionary = null
var _level_data = null
var _player_ids = null
var barrier_networkmasters = null


func _ready():
	# Create our LevelGenerator node.
	add_child(_level_generator)
	_level_dictionary = _level_generator.get_level_dictionary()


func begin(player_ids, path):
	"""
	Begins The Game.
	"""
	_player_ids = player_ids
	
	# Network master barrier.
	barrier_networkmasters = Barrier.new(get_tree(), funcref(self, "set_network_masters"))
	
	# Tell everyone to generate the level.
	_level_generator.add_level(path)  # this gets distributed to all clients
	rpc("generate_level")
	
remotesync func generate_level():
	_level_generator.build_level()
	rpc("level_built")

master func level_built():
	var pid = get_tree().get_rpc_sender_id()
	barrier_networkmasters.client_ready(pid)
	
func set_network_masters():
	"""
	Set the network masters for all player nodes.
	"""
	var player_nodes = _level_dictionary._object_id_dict.get(GameNodeIds.GameNodeID.TestPlayer, [])
	
	for i in range(min(len(player_nodes), len(_player_ids))):
		player_nodes[i].give_control_to(_player_ids[i])
