extends Button

signal master_start_game

func _ready():
	set_disabled(true)

func enable_game_button():
	"""Enables this button."""
	set_disabled(false)

func _on_StartGame_pressed():
	"""Called on click. Ensures we're the network master."""
	if is_network_master():
		emit_signal("master_start_game")

func _on_LevelStatus_status_updated(status_dict):
	if is_network_master():
		enable_game_button()
