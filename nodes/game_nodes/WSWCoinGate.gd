extends GameNode


func get_game_node_id():
	return GameNodeIds.GameNodeID.WSWCoinGate

func _ready():
	# Initiate states.
	set_attribute("Opened", 0)
	set_attribute_function("Opened", funcref(self, "on_opened"))
	
	set_attribute("Direction", 0)
	
	add_state("PrepareOpen", null, null, null, funcref(self, "check_opened"))
	add_state("Opened")

remotesync func _post_init():
	request("PrepareOpen")
	if get_attribute("Direction"):
		$ZGate.hide()
	else:
		$XGate.hide()

func get_my_tile_logic(_questioning_node):
	if get_state() == 'PrepareOpen':
		return TileEnums.TileLogic.Wall
	return null

func check_opened(delta):
	for coin in _level_dictionary._object_id_dict[GameNodeIds.GameNodeID.WSWRainbowCoin]:
		if not coin.get_attribute("__Collected"):
			return
	
	# Oh -- we're opened, neat.
	self.request("Opened")
	set_attribute("Opened", 1)

func on_opened(_new_val):
	$AnimationPlayer.play("Open")
