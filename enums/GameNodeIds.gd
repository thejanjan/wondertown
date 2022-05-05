extends Node


"""
Keeps track of all GameNodeIDs.
"""

enum GameNodeID {
	TestBox = 0
	TestPlayer = 1
}


const GameNodeIDInstances = {
	GameNodeID.TestPlayer: preload("res://nodes/game_nodes/player.tscn"),
	GameNodeID.TestBox: preload("res://nodes/game_nodes/simple_block.tscn"),
}


func make_instance(id):
	"""
	Returns an instance of a node given a GameNodeID enum.
	"""
	return GameNodeIDInstances[id].instance()
