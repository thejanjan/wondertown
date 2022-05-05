extends Label

signal updated_chat_label

var message_count = 0


func _on_Chatbox_chat_received(chat_message):
	"""Appends a chat message to this label."""
	message_count += 1
	if message_count == 1:
		set_text(chat_message)
	else:
		set_text(
			get_text() + '\n' + chat_message
		)
	emit_signal("updated_chat_label")
