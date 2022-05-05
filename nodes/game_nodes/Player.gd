extends GameNode

# Node settings.
func get_game_node_id():
	return GameNodeIds.GameNodeID.TestPlayer

# Player properties.
var movement_delay = 12;


# Declare member variables here. Examples:
var movement_debounce = 0;
var _current_pos = null;

var key_map = {
	KEY_LEFT: Vector3.LEFT,
	KEY_RIGHT: Vector3.RIGHT,
	KEY_UP: Vector3.FORWARD,
	KEY_DOWN: Vector3.BACK,
};


# Called when the node enters the scene tree for the first time.
func _ready():
	# Initiate current pos accordingly.
	_current_pos = self.global_transform.origin


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self._do_translate(delta);
	

func _physics_process(delta):
	self._attempt_movement();


func _attempt_movement():
	# Attempts to move this object a certain way.
	if self.movement_debounce > 0:
		# Cannot move at this time
		self.movement_debounce -= 1;
		return;
	
	# Attempt to move according to keymap.
	for key in self.key_map:
		var vec = self.key_map[key];
		if Input.is_key_pressed(key):
			self._current_pos += vec;
			self.movement_debounce = self.movement_delay - 1;
			return;


func _do_translate(delta):
	# If we are moving, do the translation action.
	self.translation = self.translation.move_toward(
		self._current_pos,
		(1.0 / self.movement_delay) * (delta / (1.0 / 60.0))
	);
