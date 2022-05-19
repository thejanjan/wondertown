extends GameNode

# Node settings.
func get_game_node_id():
	return GameNodeIds.GameNodeID.WoodenBox

# Called when the node enters the scene tree for the first time.
func _ready():
	# Initiate states.
	self.add_state(
		"Play",
		null,
		null,
		funcref(self, "_do_translate"),
		funcref(self, "_attempt_movement")
	)

remotesync func _post_init():
	# Go through states.
	self.request("Play")


func _do_translate(delta):
	# If we are moving, do the translation action.
	var goal_vec = self.get_pos_as_vector()
	self.translation = self.translation.move_toward(
		goal_vec,
		(1.0 / self.movement_delay) * (delta / (1.0 / 60.0))
	);

func on_gamenode_enter_us(node, id, from: Vector2, to: Vector2):
	"""
	This method is called whenever any gamenode
	enters the position that we are standing on.
	"""
	pass

func _attempt_movement(delta):
	# Attempts to move this object a certain way.
	if not can_be_controlled():
		return
	
	if self.movement_debounce > 0:
		# Cannot move at this time
		self.movement_debounce -= 1;
		return;
	
	# Attempt to move according to keymap.
	for key in self.key_map:
		var vec = self.key_map[key];
		if Input.is_key_pressed(key):
			var xpos = vec[0]
			var ypos = vec[1]
			if self.check_tile_logic(xpos, ypos) == TileEnums.TileLogic.Floor:
				self.move_pos(xpos, ypos)
				self.movement_debounce = self.movement_delay - 1;
				return;
