extends Spatial
class_name TileNode


"""
The logic/visual representation of all tiles.
"""

# Object properties.
export var xpos = 0
export var ypos = 0
export var logic = 0
export var visual = 0

func set_tilenode_pos(xpos, ypos, translate=false):
	"""
	Sets the tilenode's position.
	"""
	self.xpos = xpos
	self.ypos = ypos
	if translate:
		self.translate(Vector3(xpos, 0, ypos))

func get_xpos():
	return xpos
	
func get_ypos():
	return ypos

func initialize(logic, visual):
	"""
	Initialize the TileNode. Do not override.
	"""
	self.logic = logic
	self.visual = visual

"""
Logic handlers
"""

func get_logic():
	return logic
