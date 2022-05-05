extends GameNode

# Node settings.
func get_game_node_id():
	return GameNodeIds.GameNodeID.TestPlayer

# Player properties.
var movement_delay = 12;


# Declare member variables here. Examples:
var movement_debounce = 0;

var key_map = {
	KEY_LEFT: [-1, 0],
	KEY_RIGHT: [1, 0],
	KEY_UP: [0, -1],
	KEY_DOWN: [0, 1],
};


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
	
	# Enter play state.
	self.request("Play")


func _do_translate(delta):
	# If we are moving, do the translation action.
	self.translation = self.translation.move_toward(
		self.get_pos_as_vector() + Vector3(0, 1, 0),
		(1.0 / self.movement_delay) * (delta / (1.0 / 60.0))
	);


func _attempt_movement(delta):
	# Attempts to move this object a certain way.
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
			self.move_pos(xpos, ypos)
			self.movement_debounce = self.movement_delay - 1;
			return;
