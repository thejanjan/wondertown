extends Node


"""
Various enums for Tile options.
"""

enum TileLogic {
	None = -1
	Floor = 0
	Wall = 1
}


enum TileVisual {
	Floor = 0
	Wall = 1
}

"""
Caching
"""

var model_path = "res://models/tiles/images/"
var extension = ".png"
var cache = {}

func load_with_cache(file_name):
	if file_name in cache:
		return cache[file_name]
	
	# load the file and store it in the cache
	var tex = load(model_path + file_name + extension)
	cache[file_name] = tex
	return tex
