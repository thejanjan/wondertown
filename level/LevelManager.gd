extends Node


"""
The LevelManager is the highest-order node for running and creating a level.
It is the interface for any object to interact with whenever a level is to be made.

A Level is a high-order scene node that generates an entire level within it.
"""

# Create the helper nodes for the LevelManager.
var _level_generator = null
var _level = null
var _level_dictionary = null


func _ready():
	# Create our LevelGenerator node.
	_level_generator = preload("res://level/LevelGenerator.tscn").instance()
	self.add_child(_level_generator)
	
	# Load a test tileset.
	# TODO - refactor to an external class.
	_level = preload("res://level/templates/Level_Headphones.tscn").instance()
	self._level_generator.add_level(_level)
	
	# Build the test tileset.
	self._level_generator.build_level()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
