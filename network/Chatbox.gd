extends Control


signal chat_received

var player_name_dict = {}


func get_player_names(name_dict):
	"""
	Receive player names upon update.
	Must take in an outgoing name dict signal.
	"""
	player_name_dict = name_dict


func _on_MessageBox_text_entered(chat_message):
	"""
	Called when a chat message is received.
	Broadcasts the chat message.
	"""
	rpc("broadcast_message", chat_message)
	

remotesync func broadcast_message(chat_message):
	"""Broadcasts a chat message for all to see."""
	var rpc_id = get_tree().get_rpc_sender_id()
	var player_name = player_name_dict.get(rpc_id, "Unknown")
	emit_signal("chat_received", player_name + ": " + chat_message)
