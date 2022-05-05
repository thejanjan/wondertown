extends GameNode


# Node settings.
func get_game_node_id():
	return GameNodeIds.GameNodeID.Sign


# Called when the node enters the scene tree for the first time.
func _ready():
	# Set attributes.
	set_attribute("Dialogue", "")
	
	self.add_state("SignLoop",
		funcref(self, "set_sign_message"),
		null,
		null,
		funcref(self, "listen_for_controllers")
	)

remotesync func _post_init():
	# Go through states.
	self.request("SignLoop")

func set_sign_message():
	var dialogue_str: String = get_attribute("Dialogue")
	var new_str = ""
	for character in dialogue_str:
		if character == '#':
			new_str += '\n'
		else:
			new_str += character
	$Message/Label.set_text(new_str)

func listen_for_controllers(delta):
	"""
	Decide if we should enter the unpress state,
	depending on our current button type.
	"""
	if can_be_controlled():
		return
	for node in _level_dictionary.get_objects_at_pos(get_xpos(), get_ypos()):
		if not node.ignores(self) and node.can_be_controlled():
			return show_message()
	hide_message()

func show_message():
	$Message.visible = true

func hide_message():
	$Message.visible = false
