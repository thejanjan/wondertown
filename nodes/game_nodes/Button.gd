extends GameNode

var ButtonType_Circle = 0
var ButtonType_Square = 1

# Button variables.
var _button_node = null


# Node settings.
func get_game_node_id():
	return GameNodeIds.GameNodeID.GeneralButton


# Called when the node enters the scene tree for the first time.
func _ready():
	# Set attributes.
	set_attribute("ButtonType", ButtonType_Circle)
	set_attribute("Color", [1, 1, 1])
	set_attribute("ColorKey", 0)
	set_attribute("_ButtonPressed", 0)
	
	add_to_attribute("GameIDIgnore", get_game_node_id())
	
	# Initiate states.
	self.add_state("Initialize", funcref(self, "button_initialize"))
	self.add_state("Depressed",
		null,
		funcref(self, "on_button_press"),
		funcref(self, "process_depress"),
		funcref(self, "player_control")
	)
	self.add_state("Pressed",
		null,
		funcref(self, "on_button_depress"),
		funcref(self, "process_press"),
		funcref(self, "player_control")
	)

remotesync func _post_init():
	# Go through states.
	self.request("Initialize")
	self.request("Depressed")


func button_initialize():
	"""
	Initializes button properties, such as the 
	appearance of the button.
	"""
	# Hide all children.
	for child in self.get_children():
		child.visible = false
	
	# First, we gotta find what button we're trying to use.
	var buttonType = int(get_attribute("ButtonType"))
	self._button_node = {
		ButtonType_Circle: $Circle,
		ButtonType_Square: $Square
	}.get(buttonType)
	
	# Set the color of our button node.
	self._button_node.visible = true
	self._button_node.find_node("Color").material = SpatialMaterial.new()
	update_button_color()

func player_control(delta):
	"""
	Because why not have the button be controllable?
	"""
	if not can_be_controlled():
		return
	if Input.is_action_pressed("ui_accept"):
		if self.get_state() == 'Depressed':
			self.request('Pressed')
			return
	else:
		if self.get_state() == 'Pressed':
			if get_attribute("ButtonType") in [ButtonType_Square]:
				return
			self.request('Depressed')
			return

"""
Button transitions
"""

func on_button_press():
	"""
	Looks for all GameNodes with equal Color and ColorKey
	and sets their ButtonActive attribute.
	"""
	update_button_color(0.25)
	for node in get_all_game_nodes():
		if self.attr_equal("Color", node) and self.attr_equal("ColorKey", node):
			node.set_attribute("_ButtonPressed", 1)
	
func on_button_depress():
	"""
	Looks for all GameNodes with equal Color and ColorKey
	and sets their ButtonActive attribute.
	"""
	update_button_color()
	for node in get_all_game_nodes():
		if self.attr_equal("Color", node) and self.attr_equal("ColorKey", node):
			node.set_attribute("_ButtonPressed", 0)

"""
Button process variables
"""

func process_press(delta):
	"""
	Decide if we should enter the unpress state,
	depending on our current button type.
	"""
	if can_be_controlled():
		return
	if get_attribute("ButtonType") == ButtonType_Circle:
		for node in _level_dictionary.get_objects_at_pos(get_xpos(), get_ypos()):
			if not node.ignores(self):
				# There is a node at our position that doesn't ignore us,
				# do not enter the depressed state.
				return
		# Ok, there is no other node at this position.
		# I am so depressed.
		self.request("Depressed")
	
func process_depress(delta):
	if can_be_controlled():
		return
	if get_attribute("ButtonType") in [ButtonType_Circle, ButtonType_Square]:
		for node in _level_dictionary.get_objects_at_pos(get_xpos(), get_ypos()):
			if not node.ignores(self):
				# There is a node at our position that doesn't ignore us,
				# we should enter the press state.
				self.request("Pressed")

"""
Button visual state
"""

func update_button_color(mult=1.0):
	"""
	Updates the button color.
	"""
	var c1 = get_attribute("Color")
	var c1_color = Color(c1[0] * mult, c1[1] * mult, c1[2] * mult)
	_button_node.find_node("Color").material.albedo_color = c1_color
