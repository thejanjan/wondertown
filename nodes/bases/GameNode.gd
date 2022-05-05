extends Spatial
class_name GameNode


"""
The base class of all gameplay elements.
All gameplay elements can extend a GameNode.
"""

# Overwrite these in extended nodes.
func get_game_node_id():
	return GameNodeIds.GameNodeID.TestBox

# Do not touch these.
# The ID of an object is a unique identifier given to a GameNode
# once it is created by the LevelGenerator. The LevelDictionary
# has a built-in dict from object id to object.
var id = null

# Object properties.
export var xpos = 0
export var ypos = 0

# References to level singletons.
var _level_manager = null
var _level_dictionary = null


func initialize(set_id, level_manager_ref, level_dictionary_ref):
	"""
	Initialize the GameNode. Do not override.
	"""
	id = set_id
	_level_manager = level_manager_ref
	_level_dictionary = level_dictionary_ref
	

func set_gamenode_pos(xpos, ypos, translate=false):
	"""
	Sets the gamenode's position.
	"""
	self.xpos = xpos
	self.ypos = ypos
	if translate:
		self.translate(Vector3(xpos, 0, ypos))


func _cleanup():
	"""
	Called whenever the game node enters the Off state.
	"""
	pass

"""
FSM pattern
"""

var _current_state = "Off"
var _transition_state = null
var state_list = {
	"Off": [funcref(self, "_cleanup"), null, null, null]
}

func add_state(state_name, enter_func=null, exit_func=null, process_func=null, physics_process_func=null):
	"""
	Adds a state to the game node FSM.
	"""
	assert(not state_list.has(state_name))
	
	state_list[state_name] = [enter_func, exit_func, process_func, physics_process_func]


func request(state_name, exit_args=[], enter_args=[]):
	"""
	Requests a state to enter.
	"""
	# Are we already in a state transition?
	if (_transition_state != null):
		push_error("GameNode attempted to request state mid-transition.")
	
	# Set our state variables pre-transition.
	_transition_state = _current_state
	_current_state = null
	
	# Call our exit function.
	var exit_func = state_list[_transition_state][1]
	if (exit_func != null):
		exit_func.call_funcv(exit_args)
	
	# Call our entrance function.
	var enter_func = state_list[state_name][1]
	if (enter_func != null):
		enter_func.call_funcv(enter_args)
	
	# Reset our transition state.
	_transition_state = null
	_current_state = state_name


func get_state():
	"""
	Returns the current state of the GameNode.
	Returns null if in transition.
	"""
	return _current_state

"""
Process methods
"""

func _process(delta):
	"""
	Process is handled state-by-state.
	"""
	var state = get_state()
	
	# Figure out what our callback should be.
	var process_func = state_list[state][2]
	
	# Run our process func.
	if (process_func != null):
		process_func.call_func(delta)


func _physics_process(delta):
	"""
	Process is handled state-by-state.
	"""
	var state = get_state()
	
	# Figure out what our callback should be.
	var physics_process_func = state_list[state][3]
	
	# Run our process func.
	if (physics_process_func != null):
		physics_process_func.call_func(delta)
