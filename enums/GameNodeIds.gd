extends Node


"""
Keeps track of all GameNodeIDs.
"""

enum GameNodeID {
	TestBox = 0
	TestPlayer = 1
	GeneralButton = 2
}


const GameNodeIDInstances = {
	GameNodeID.TestBox: preload("res://nodes/tile_nodes/simple_block.tscn"),
	GameNodeID.TestPlayer: preload("res://nodes/game_nodes/player.tscn"),
	GameNodeID.GeneralButton: preload("res://nodes/game_nodes/Button.tscn"),
}


func make_instance(id):
	"""
	Returns an instance of a node given a GameNodeID enum.
	"""
	var packed_scene = GameNodeIDInstances.get(int(id))
	return packed_scene.instance()
