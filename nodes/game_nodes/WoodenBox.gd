extends GameNode

var movement_debounce = 1
var player_node = null

# Node settings.
func get_game_node_id():
	return GameNodeIds.GameNodeID.WoodenBox

# Called when the node enters the scene tree for the first time.
func _ready():
	# Initiate states.
	self.add_state(
		"Still",
		funcref(self, "set_player_node"),
		null,
		funcref(self, "_ensure_position"),
		funcref(self, "_attempt_movement")
	)
	self.add_state(
		"PushedByPlayer",
		funcref(self, "set_player_node"),
		null,
		funcref(self, "_do_translate_player"),
		funcref(self, "_attempt_movement")
	)
	network_state("Still")
	network_state("PushedByPlayer")

remotesync func _post_init():
	# Go through states.
	self.request("Still")

func _ensure_position(_delta):
	self.translation = self.get_pos_as_vector()

func _do_translate_player(delta):
	# If we are moving, do the translation action.
	var goal_vec = self.get_pos_as_vector()
	self.translation = self.translation.move_toward(
		goal_vec,
		(1.0 / 12.0) * (delta / (1.0 / 60.0))
	);
	self.movement_debounce = 5
	if self.translation == goal_vec:
		self.request("Still")

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

"""
Movement functionality
"""

func get_my_tile_logic(questioning_node):
	match questioning_node.get_game_node_id():
		GameNodeIds.GameNodeID.TestPlayer:
			# A player is attempting to move us.
			var vec = questioning_node.get_attribute('__MovingTo')
			var xpos = vec[0]
			var ypos = vec[1]
			if self.check_tile_logic(xpos, ypos) == TileEnums.TileLogic.Floor:
				# The player is allowed to move us.
				self.move_pos(xpos, ypos)
				self.request('PushedByPlayer', [], [questioning_node.get_name()])
				return TileEnums.TileLogic.Floor
	
	# If all else fails, we pretend to be a wall.
	return TileEnums.TileLogic.Wall

func on_gamenode_enter_us(node, id, from: Vector2, to: Vector2):
	"""
	This method is called whenever any gamenode
	enters the position that we are standing on.
	"""
	pass

func set_player_node(node=null):
	"""
	Sets the pushing state of the player node pushing us.
	"""
	if node is String:
		node = get_parent().find_node(node, false, false)
	if node == player_node:
		return
	if player_node:
		player_node.set_attribute('__Pushing', 0)
		player_node = null
	if node:
		player_node = node
		player_node.set_attribute('__Pushing', 1)
