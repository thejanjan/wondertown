extends GameNode


# Node settings.
func get_game_node_id():
	return GameNodeIds.GameNodeID.GeneralButton


# Called when the node enters the scene tree for the first time.
func _ready():
	# Set attributes.
	set_attribute("Color", [1, 1, 1])
	set_attribute("ColorKey", 0)
	set_attribute("_ButtonPressed", 0)
	
	set_attribute("OpenSpeed", 1.25)
	set_attribute("CloseSpeed", 0.9)
	
	set_attribute("TileLogicOverride", [TileEnums.TileLogic.Wall])
	
	set_attribute_function("_ButtonPressed", funcref(self, "button_activation"))
	
	# Initiate states.
	self.add_state("Init", funcref(self, "gate_initialize"))
	self.add_state("Open",
		null,
		null,
		funcref(self, "process_open"),
		null
	)
	self.add_state("Close",
		null,
		null,
		funcref(self, "process_close"),
		null
	)

func _post_init():
	# Go through states.
	self.request("Init")
	self.request("Close")


func gate_initialize():
	"""
	Initializes appearances of the gate.
	"""
	# Set the color of our gate.
	update_gate_color()

"""
Gate transitions
"""

func button_activation(mode):
	"""
	Switches state when this gate's
	button activation state changes.
	"""
	if mode == 0:
		self.request("Close")
	else:
		self.request("Open")

"""
Gate process variables
"""

func get_goal_pos():
	return self.get_pos_as_vector() + Vector3(0, -1.2, 0)

func process_open(delta):
	"""
	Move to the Open position.
	"""
	self.translation = self.translation.move_toward(
		get_goal_pos(), delta * get_attribute("OpenSpeed")
	);
	
func process_close(delta):
	"""
	Move to the Close position.
	"""
	var goal_pos = self.get_pos_as_vector() + Vector3(0, 0, 0)
	self.translation = self.translation.move_toward(
		goal_pos, delta * get_attribute("CloseSpeed")
	);
	set_attribute("TileLogicOverride", [TileEnums.TileLogic.Wall])

func get_my_tile_logic(questioning_node):
	if self.translation == get_goal_pos():
		return TileEnums.TileLogic.Wall
	return null

"""
Gate visual state
"""

func update_gate_color():
	"""
	Updates the gate color.
	"""
	var c1 = get_attribute("Color")
	var c1_color = Color(c1[0], c1[1], c1[2])
	$Root/Color.material = SpatialMaterial.new()
	$Root/Color.material.albedo_color = c1_color
