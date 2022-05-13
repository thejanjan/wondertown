extends ScrollContainer

var has_new_message = false

func _on_ChatMessages_updated_chat_label():
	has_new_message = true

func _on_MessageLogger_draw():
	"""
	On rendering of the MessageLogger, decide if we need to
	keep its vscroll at the very bottom.
	"""
	if has_new_message:
		set_v_scroll(get_v_scroll() + 10000)
	has_new_message = false
