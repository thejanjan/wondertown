extends Control


"""
The GUI for a WSW level.
"""

var level_dictionary = null
var max_rainbow = 0
var max_bonus = 0

func set_level_dict(dict):
	level_dictionary = dict
	max_rainbow = len(get_rainbow_coin_nodes())
	max_bonus = len(get_bonus_coin_nodes())
	update_coin_gui()

func _process(delta):
	"""
	Try to update the GUI whenever we can.
	"""
	if not level_dictionary:
		return
	var coins_collected = get_collected_coins()
	update_coin_gui(coins_collected[0], coins_collected[1])

func get_collected_coins():
	var rainbow_count = 0
	var bonus_count = 0
	for rainbow_coin_node in get_rainbow_coin_nodes():
		if rainbow_coin_node.get_attribute("__Collected"):
			rainbow_count += 1
	for bonus_coin_node in get_bonus_coin_nodes():
		if bonus_coin_node.get_attribute("__Collected"):
			bonus_count += 1
	return [rainbow_count, bonus_count]

func update_coin_gui(rainbow: int = 0, bonus: int = 0):
	if not max_bonus:
		$CoinCount.set_text(
			"Coins: " + str(rainbow) + " of " + str(max_rainbow)
		)
	else:
		$CoinCount.set_text(
			"Coins: " + str(rainbow) + " of " + str(max_rainbow) +
			"\nBonus: " + str(bonus) + " of " + str(max_bonus)
		)

"""
Level dict getters
"""

func get_rainbow_coin_nodes():
	return level_dictionary._object_id_dict[GameNodeIds.GameNodeID.WSWRainbowCoin]

func get_bonus_coin_nodes():
	return level_dictionary._object_id_dict[GameNodeIds.GameNodeID.WSWBonusCoin]
