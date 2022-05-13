extends Control

# Default game server port. Can be any number between 1024 and 49151.
# Not on the list of registered or common ports as of November 2020:
# https://en.wikipedia.org/wiki/List_of_TCP_and_UDP_port_numbers
const DEFAULT_PORT = 8910

onready var connection = $Connection
onready var address = $Connection/Address
onready var host_button = $Connection/HostButton
onready var join_button = $Connection/JoinButton
onready var player_list = $PostConnection/ConnectedPlayerLabel/Players

var active_players = []
var peer = null

signal player_list_update

func _ready():
	# Connect all the callbacks related to networking.
	get_tree().connect("network_peer_connected", self, "_player_connected")
	get_tree().connect("network_peer_disconnected", self, "_player_disconnected")
	get_tree().connect("connected_to_server", self, "_connected_ok")
	get_tree().connect("connection_failed", self, "_connected_fail")
	get_tree().connect("server_disconnected", self, "_server_disconnected")
	
	# Show GUI accordingly
	show_connection_gui(0)

#### Network callbacks from SceneTree ####

# Callback from SceneTree.
func _player_connected(_id):
	print("connection: " + str(_id))
	active_players.append(_id)
	emit_signal("player_list_update", active_players)

func _player_disconnected(_id):
	print("disconnected: " + str(_id))
	active_players.erase(_id)
	emit_signal("player_list_update", active_players)

# Callback from SceneTree, only for clients (not server).
func _connected_ok():
	print("_connected_ok")
	
	# Tell the server our username.
	player_list.request_name($Connection/PlayerName.get_text())
	
	# Disable buttons.
	host_button.set_disabled(true)
	join_button.set_disabled(true)
	
	# Show GUI.
	show_connection_gui(1)

# Callback from SceneTree, only for clients (not server).
func _connected_fail():
	print("connection fail")
	
	_set_status("Couldn't connect", false)

	get_tree().set_network_peer(null) # Remove peer.
	host_button.set_disabled(false)
	join_button.set_disabled(false)


func _server_disconnected():
	print("server disconnected")
	leave_lobby()

##### Game creation functions ######

func _end_game(with_error = ""):
	if has_node("/root/Pong"):
		# Erase immediately, otherwise network might show
		# errors (this is why we connected deferred above).
		get_node("/root/Pong").free()
		show()

	get_tree().set_network_peer(null) # Remove peer.
	host_button.set_disabled(false)
	join_button.set_disabled(false)

	_set_status(with_error, false)

func leave_lobby():
	get_tree().set_network_peer(null)
	host_button.set_disabled(false)
	join_button.set_disabled(false)
	show_connection_gui(0)
	active_players = []
	emit_signal("player_list_update", active_players)


func _set_status(text, isok):
	# Simple way to show status.
	var ok_str = "ok" if isok else "bad"
	print("(" + ok_str + "): " + text)


func _on_host_pressed():
	peer = NetworkedMultiplayerENet.new()
	peer.set_compression_mode(NetworkedMultiplayerENet.COMPRESS_RANGE_CODER)
	var err = peer.create_server(DEFAULT_PORT, 1) # Maximum of 1 peer, since it's a 2-player game.
	if err != OK:
		# Is another server running?
		_set_status("Can't host, address in use.",false)
		return

	get_tree().set_network_peer(peer)
	host_button.set_disabled(true)
	join_button.set_disabled(true)
	_set_status("Waiting for player...", true)
	
	# Add our name.
	player_list.request_name($Connection/PlayerName.get_text())
	active_players.append(1)
	show_connection_gui(1)


func _on_join_pressed():
	var ip = address.get_text()
	if not ip:
		ip = "127.0.0.1"
	if not ip.is_valid_ip_address():
		_set_status("IP address is invalid", false)
		return

	peer = NetworkedMultiplayerENet.new()
	peer.set_compression_mode(NetworkedMultiplayerENet.COMPRESS_RANGE_CODER)
	peer.create_client(ip, DEFAULT_PORT)
	get_tree().set_network_peer(peer)

	_set_status("Connecting...", true)
	active_players.append(1)


func show_connection_gui(mode: int):
	"""Shows the connection gui."""
	if mode:
		$Connection.hide()
		$PostConnection.show()
	else:
		$Connection.show()
		$PostConnection.hide()
