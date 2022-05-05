extends ItemList

signal updated_player_names
var player_names = {}


func request_name(name):
	"""
	Requests a player name to the server.
	"""
	rpc("add_player_name", name)

master func add_player_name(name):
	"""
	Adds a player name to the server.
	"""
	var id = get_tree().get_rpc_sender_id()
	player_names[id] = validate_name(name)
	rpc("update_player_list", player_names)

master func remove_player_name():
	"""
	Removes a player name from the server.
	"""
	var id = get_tree().get_rpc_sender_id()
	player_names.erase(id)
	rpc("update_player_list", player_names)

remotesync func update_player_list(player_names):
	"""
	Updates the tree's player list.
	"""
	# Do we update our player name list?
	if not is_network_master():
		self.player_names = player_names
	emit_signal("updated_player_names", player_names)
	
	_update_gui()

func update_name_list(player_ids):
	var new_name_dict = {}
	for name in player_ids:
		if name in player_names:
			new_name_dict[name] = player_names[name]
	player_names = new_name_dict
	_update_gui()

func _update_gui():
	# Build GUI
	clear()
	for rpc_id in player_names:
		var name = player_names[rpc_id]
		add_item(name, null, false)

"""
Name validation
"""

func validate_name(name):
	"""
	Validates the name received.
	"""
	if not name:
		name = "Player"
	var id = 0
	var id_str = ""
	while (name + id_str) in player_names.values():
		id += 1
		id_str = str(id)
	return name + id_str
