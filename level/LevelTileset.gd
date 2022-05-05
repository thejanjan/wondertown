extends TileMap


"""
The LevelTileset stores the information on how to map
each tileset index into an instanced scene.
"""


var _tile_to_scene = {
	0: preload("res://level/level_entities/simple_block.tscn"),
	1: preload("res://level/level_entities/player.tscn"),
}


func get_tile_mapping():
	"""
	Creates a dictionary tile mapping, containing
	a map from Tile ID : Vector2D array.
	"""
	
	var tile_mapping = {}
	
	# Populate mapping with array2ds.
	for id in GameNodeIds.GameNodeIDInstances:
		tile_mapping[id] = []
	
	# Populate tile mapping with tile vec2ds.
	for id in GameNodeIds.GameNodeIDInstances:
		# kinda gross hack to work with walls
		var vec2d_array = []
		if id == 0:
			vec2d_array = self.get_used_cells()
		else:
			vec2d_array = self.get_used_cells_by_id(id)
		
		# populate with cells of this id
		for vec2d in vec2d_array:
			tile_mapping[id].append(vec2d) 
	
	# we are done here
	return tile_mapping


func get_instance(tile_id):
	"""
	Gets an instance from a tile id.
	"""
	return GameNodeIds.make_instance(tile_id)
