extends Node


"""
Keeps track of all GameNodeIDs.
"""

enum GameNodeID {
	TestPlayer = 1
	GeneralButton = 2
	Gate = 3
}


const GameNodeIDInstances = {
	GameNodeID.TestPlayer: preload("res://nodes/game_nodes/player.tscn"),
	GameNodeID.GeneralButton: preload("res://nodes/game_nodes/Button.tscn"),
	GameNodeID.Gate: preload("res://nodes/game_nodes/Gate.tscn"),
}


func make_instance(id):
	"""
	Returns an instance of a node given a GameNodeID enum.
	"""
	var packed_scene = GameNodeIDInstances.get(int(id))
	return packed_scene.instance()
