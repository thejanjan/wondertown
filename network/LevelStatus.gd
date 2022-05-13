extends Panel

onready var label_levelName = $LevelName
var level_data = {}


func on_level_selected(file, path):
	"""Ran when a level is selected from the LevelList."""
	if not is_network_master():
		return
	
	# Create a level data dict.
	level_data = {
		"name": file
	}
	
	# RPC transmit it to everyone.
	rpc("update_level_data", level_data)

remotesync func update_level_data(level_data):
	"""
	Receives level data, updates GUI accordingly.
	"""
	label_levelName.set_text("Level selected: " + level_data["name"])
