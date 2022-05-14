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

# References to level singletons.
var _level_manager = null
var _level_dictionary = null

# External attributes.
# Set on the node from an external editor.
var external_attributes = {}
var external_attribute_function_hooks = {}

"""
Godot node methods
"""

func _ready():
	# Default GameNode attributes
	set_attribute("xpos", 0)
	set_attribute("ypos", 0)
	
	set_attribute("Active", 1)
	set_attribute("ButtonActive", 0)
	set_attribute("ProcessActive", 1)
	set_attribute("PhysicsActive", 1)
	set_attribute("GameIDIgnore", [])
	
	# Private GameNode attributes
	set_attribute("TileLogicOverride", [])

func initialize(set_id, level_manager_ref, level_dictionary_ref):
	"""
	Initialize the GameNode.
	"""
	id = set_id
	_level_manager = level_manager_ref
	_level_dictionary = level_dictionary_ref
	
	# Post init now.
	# Do as RPC to avoid race conditions with attributes
	rpc("_post_init")
	
remotesync func _post_init():
	"""
	Can be overriden.
	Use this to initialize state after attributes are set.
	"""
	pass

func _cleanup():
	"""
	Called whenever the game node enters the Off state.
	"""
	pass

"""
Network attributes
"""

func give_control_to(peer_id):
	"""Gives control of this node to a peer ID."""
	# Let all clients know about the control update.
	rpc("_receive_control", peer_id)
	
	# Give control to the node.
	self.set_network_master(peer_id)
	
remotesync func _receive_control(peer_id):
	"""Master tells us who this node is now controled by."""
	if is_network_master():
		on_lose_master()
	self.set_network_master(peer_id)
	if is_network_master():
		on_receive_master()

func on_lose_master():
	"""Called on the master of this node when the master is lost."""
	pass

func on_receive_master():
	"""Called on the master of this node when the master is gained."""
	pass

"""
External attributes
"""

func update_attribute_dict(attr_dict):
	"""
	When building the TileNode, we get the attribute dict
	from the WTL file and apply it to this object.
	"""
	for key in attr_dict:
		var value = attr_dict[key]
		set_attribute(key, value)
	
func set_attribute(key, value):
	"""
	Sets an attribute on this object.
	"""
	external_attributes[key] = value
	rpc("network_attribute", key, value)
	
	# Call any function hooks.
	var func_hooks = external_attribute_function_hooks.get(key, [])
	for func_ref in func_hooks:
		func_ref.call_func(value)

remotesync func network_attribute(key, value):
	external_attributes[key] = value

func add_to_attribute(key, value):
	"""
	Adds to an attribute on this object.
	Must be a list.
	"""
	var attr_list = external_attributes.get(key, [])
	attr_list.append(value)
	set_attribute(key, attr_list)

func get_attribute(key):
	"""
	Gets an attribute on this object.
	"""
	return external_attributes.get(key)

func set_attribute_function(key, func_ref):
	"""
	Sets an attribute function.
	When the attribute updates, the function ref will be called.
	"""
	if external_attribute_function_hooks.get(key) == null:
		external_attribute_function_hooks[key] = []
	external_attribute_function_hooks[key].append(func_ref)

"""
Various getters
"""

func ignores(game_node):
	"""
	Sees if this game node "ignores" another one.
	This is done by comparing this nodes ignore ID list,
	and seeing if the other game node's ID is in this list.
	"""
	return game_node.get_game_node_id() in get_attribute("GameIDIgnore")

func attr_equal(attr, node_a, node_b=null):
	"""
	Checks if the attributes are equal between two nodes.
	"""
	if node_b == null:
		node_b = self
	return node_a.get_attribute(attr) == node_b.get_attribute(attr)

"""
Position methods
"""

func set_gamenode_pos(xpos, ypos, translate=false):
	"""
	Sets the gamenode's position.
	"""
	set_attribute("xpos", xpos)
	set_attribute("ypos", ypos)
	if translate:
		self.translate(Vector3(xpos, 0, ypos))


func move_pos(xpos_diff, ypos_diff, translate=false):
	set_gamenode_pos(get_xpos() + xpos_diff, get_ypos() + ypos_diff, translate)
	
func get_pos_as_vector():
	return Vector3(get_xpos(), 0, get_ypos())
	
func get_xpos():
	return get_attribute("xpos")
	
func get_ypos():
	return get_attribute("ypos")

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
	var enter_func = state_list[state_name][0]
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

func get_transition_state():
	"""
	Returns the state we are exiting, assuming that
	we are currently in a state transition.
	Null if we are not in a transition.
	"""
	return _transition_state

"""
Process methods
"""

func _process(delta):
	"""
	Process is handled state-by-state.
	"""
	# No process if we are inactive.
	if not get_attribute("Active"):
		return
	if not get_attribute("ProcessActive"):
		return
	
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
	# No process if we are inactive.
	if not get_attribute("Active"):
		return
	if not get_attribute("PhysicsActive"):
		return
	
	var state = get_state()
	
	# Figure out what our callback should be.
	var physics_process_func = state_list[state][3]
	
	# Run our process func.
	if (physics_process_func != null):
		physics_process_func.call_func(delta)

"""
Dictionary getters
"""

func get_all_game_nodes():
	return self._level_dictionary._all_objects

func check_tile_logic(xpos, ypos, relative=true):
	"""
	Checks the tile logic at a given position.
	"""
	if not relative:
		return _level_dictionary.get_tile_logic_at_pos(xpos, ypos)
	else:
		return _level_dictionary.get_tile_logic_at_pos(get_xpos() + xpos, get_ypos() + ypos)
		
