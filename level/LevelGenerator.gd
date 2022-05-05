extends Node

"""
The LevelGenerator scene is a node that is capable of taking
a child level node, parsing its tileset data into a level in 3D space.

It will find a LevelTileset node, and then interface with it
in order create an entire level instance.
"""

const LevelTileset = preload("res://level/LevelTileset.gd")
var level_node = null
var tileset_node = null


func add_level(level):
	"""
	Adds a level node to the LevelGenerator.
	"""
	# Set the level node.
	self.level_node = level
	
	# Add the tileset.
	self._add_tileset(level.get_node("LevelTileset"))


func _add_tileset(tileset):
	"""
	Adds a tileset to the LevelGenerator.
	"""
	assert(tileset is LevelTileset)
	
	# Set the tileset node.
	self.tileset_node = tileset


func build_level():
	"""
	Builds a level from the currently set tileset.
	"""
	assert(self.tileset_node)
	
	# Get the tileset mapping.
	var tileset_mapping = self.tileset_node.get_tile_mapping()
	
	# Build nodes according to the mapping.
	for tile_id in tileset_mapping:
		var vec2d_list = tileset_mapping[tile_id]
		
		for vec2d in vec2d_list:
			var object = self.tileset_node.get_instance(tile_id)
			object.translate(Vector3(vec2d.x, 0, vec2d.y))
			self.add_child(object)
	
	# Ok, now hide the level.
	self.tileset_node.visible = false
