extends GameNode


func get_game_node_id():
	return GameNodeIds.GameNodeID.WSWRainbowCoin


func _ready():
	# Initiate states.
	set_attribute("__Collected", 0)
	set_attribute_function("__Collected", funcref(self, "on_collected"))
	$AnimationPlayer.play("CoinSpin")

func on_gamenode_enter_us(node, id, from: Vector2, to: Vector2):
	"""
	This method is called whenever any gamenode
	enters the position that we are standing on.
	"""
	if node.get_game_node_id() != GameNodeIds.GameNodeID.TestPlayer:
		return
	if not get_attribute("__Collected"):
		set_attribute("__Collected", 1)

func on_collected(_new_val):
	hide()
