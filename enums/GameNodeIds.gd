extends Node


"""
Keeps track of all GameNodeIDs.
"""

enum GameNodeID {
	TestPlayer = 1
	GeneralButton = 2
	Gate = 3
	Sign = 4
	WoodenBox = 5
	WSWExit = 6
	WSWRainbowCoin = 7
	WSWBonusCoin = 8
	WSWCoinGate = 9
}


const GameNodeIDInstances = {
	GameNodeID.TestPlayer: preload("res://nodes/game_nodes/player.tscn"),
	GameNodeID.GeneralButton: preload("res://nodes/game_nodes/Button.tscn"),
	GameNodeID.Gate: preload("res://nodes/game_nodes/Gate.tscn"),
	GameNodeID.Sign: preload("res://nodes/game_nodes/Sign.tscn"),
	GameNodeID.WoodenBox: preload("res://nodes/game_nodes/WoodenBox.tscn"),
	GameNodeID.WSWExit: preload("res://nodes/game_nodes/WSWExit.tscn"),
	GameNodeID.WSWRainbowCoin: preload("res://nodes/game_nodes/WSWRainbowCoin.tscn"),
	GameNodeID.WSWBonusCoin: preload("res://nodes/game_nodes/WSWBonusCoin.tscn"),
	GameNodeID.WSWCoinGate: preload("res://nodes/game_nodes/WSWCoinGate.tscn"),
}


func make_instance(id):
	"""
	Returns an instance of a node given a GameNodeID enum.
	"""
	var packed_scene = GameNodeIDInstances.get(int(id))
	return packed_scene.instance()
