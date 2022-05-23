extends Node

"""
The LevelGenerator scene is a scene that is capable of taking
a child level node, parsing its tileset data into a level in 3D space.

It will find a TileSet node, and then interface with it
in order create an entire level instance.
"""


func _ready():
	
	# Find tileset node.
	var level_tileset = self.find_node("LevelTileset")
	assert(level_tileset != null)
	
	# Get the tileset mapping.
	var tileset_mapping = level_tileset.get_tile_mapping()
	
	# Build nodes according to the mapping.
	for tile_id in tileset_mapping:
		var vec2d_list = tileset_mapping[tile_id]
		
		for vec2d in vec2d_list:
			var object = level_tileset.get_instance(tile_id)
			object.translate(Vector3(vec2d.x, 0, vec2d.y))
			self.add_child(object)
	
	# Ok, now hide the level.
	level_tileset.visible = false
