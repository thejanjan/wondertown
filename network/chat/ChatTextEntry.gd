extends LineEdit


func _on_MessageBox_text_entered(new_text):
	"""
	Clear this chat message upon enter.
	"""
	set_text('')
	release_focus()


func _process(delta):
	"""
	When T is pressed, open chat key.
	"""
	if is_visible_in_tree():
		if Input.is_key_pressed(KEY_T) and get_focus_owner() != self:
			grab_focus()
