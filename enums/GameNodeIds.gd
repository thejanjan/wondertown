extends Node


"""
Keeps track of all GameNodeIDs.
"""

enum GameNodeID {
	TestBox = 0
	TestPlayer = 1
}


const GameNodeIDInstances = {
	GameNodeID.TestPlayer: preload("res://level/level_entities/player.tscn"),
	GameNodeID.TestBox: preload("res://level/level_entities/simple_block.tscn"),
}


func make_instance(id):
	"""
	Returns an instance of a node given a GameNodeID enum.
	"""
	return GameNodeIDInstances[id].instance()
