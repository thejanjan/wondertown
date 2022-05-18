extends Panel

signal status_updated

var WondertownLevelData = preload("res://wts/WondertownLevelData.gd")
onready var _level_io = preload("res://wts/WondertownLevelIO.tscn").instance()
onready var label_levelName = $LevelName
var level_data = {}


func on_level_selected(file, path):
	"""Ran when a level is selected from the LevelList."""
	if not is_network_master():
		return
	
	# How many player instances are in file?
	var wtl_data: WondertownLevelData = _level_io.load_file(path)
	var player_nodes = wtl_data.get_tiles_of_attribute("PlayerOwned", 1)
	
	# Create a level data dict.
	level_data = {
		"name": file,
		"player_count": len(player_nodes)
	}
	
	# RPC transmit it to everyone.
	rpc("update_level_data", level_data)

remotesync func update_level_data(level_data):
	"""
	Receives level data, updates GUI accordingly.
	"""
	label_levelName.set_text(
		"Level selected: " + level_data["name"]
		+ "\nPlayer Count: " + str(level_data["player_count"])
	)
	
	# This status updated.
	emit_signal("status_updated", level_data)
