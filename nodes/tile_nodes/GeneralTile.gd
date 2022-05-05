extends TileNode

var tile_size = 16

onready var material = preload("res://models/tiles/tile_material.tres")

onready var Top = $Top
onready var Bottom = $Bottom
onready var Front = $Front
onready var Back = $Back
onready var Left = $Left
onready var Right = $Right

var tex_nodes = []
var texture = null

func _post_init(data):
	"""
	Special init to be handled by subclasses.
	Can be overridden.
	"""
	tex_nodes = [Top, Bottom, Front, Back, Left, Right]
	set_texture_array(data.get_tex())
	
	handle_visual_placements(data, data.get_visual())

func set_texture_array(tex_array: Array):
	for i in range(len(tex_nodes)):
		# The node to influence.
		var node = tex_nodes[i]
		
		# What texture do we wanna load?
		var file_name = tex_array[i]
		
		if file_name == '':
			# This node is hidden.
			node.hide()
		else:
			# Set texture.
			var tex = TileEnums.load_with_cache(file_name)
			node.set_material(self.material.duplicate())
			node.material.set_texture(0, tex)

func handle_visual_placements(data, visual_id):
	"""
	Places this node visually.
	"""
	if visual_id == 1:
		translate(Vector3(0, 1, 0))
