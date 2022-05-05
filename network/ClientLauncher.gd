extends Button


var client_name = 'debug-client-wt.exe'
var has_compiled = false


func _on_ClientLauncher_pressed():
	"""Launches another client for multiplayer."""
	if not has_compiled:
		# We need to compile the game.
		OS.execute(
			'godot',
			['--path D:\\Wondertown', '--export-debug', 'Windows', './' + client_name],
			true
		)
		OS.shell_open(client_name)
		has_compiled = true
	else:
		OS.shell_open(client_name)
