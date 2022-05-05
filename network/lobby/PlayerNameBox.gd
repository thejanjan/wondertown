extends LineEdit


func _on_PlayerName_text_entered(new_text):
	"""
	Clear this chat message upon enter.
	"""
	set_text('')
	release_focus()
