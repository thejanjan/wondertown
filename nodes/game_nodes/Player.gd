extends GameNode

# Node settings.
func get_game_node_id():
	return GameNodeIds.GameNodeID.TestPlayer

# Player properties.
var movement_delay = 12;
var WSWModel = null;

# do not touch these
var movement_debounce = 0;

var PlayerModels = {
	'WSWStinky': preload("res://models/game/players/wsw/stinky.tscn"),
	'WSWLoof':   preload("res://models/game/players/wsw/loof.tscn"),
	'WSWQookie': preload("res://models/game/players/wsw/qookie.tscn"),
	'WSWPeegue': preload("res://models/game/players/wsw/peegue.tscn")
}

var key_map = {
	KEY_LEFT: [-1, 0],
	KEY_RIGHT: [1, 0],
	KEY_UP: [0, -1],
	KEY_DOWN: [0, 1],
};
var player_angle = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	# Initiate states.
	set_attribute_function('Player', funcref(self, 'create_model'))
	self.add_state(
		"Play",
		null,
		null,
		funcref(self, "_do_translate"),
		funcref(self, "_attempt_movement")
	)

func _post_init():
	# Enter play state.
	self.request("Play")


func _do_translate(delta):
	# If we are moving, do the translation action.
	var goal_vec = self.get_pos_as_vector()
	self.translation = self.translation.move_toward(
		goal_vec,
		(1.0 / self.movement_delay) * (delta / (1.0 / 60.0))
	);
	
	if not WSWModel:
		return
	if self.translation != goal_vec:
		WSWModel.rotation_degrees = Vector3(0, player_angle, 0)
		WSWModel.set_moving_state(true)
	else:
		WSWModel.set_moving_state(false)

func _attempt_movement(delta):
	# Attempts to move this object a certain way.
	if not is_network_master():
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
				player_angle = (3 - (key - KEY_LEFT)) * 90
				WSWModel.set_moving_state(true)
				return;

func on_lose_master():
	$Camera.clear_current()

func on_receive_master():
	$Camera.make_current()

"""
Player Model creation
"""

func create_model(name):
	WSWModel = PlayerModels[name].instance()
	add_child(WSWModel)
