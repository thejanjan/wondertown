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
	add_child(_level_generator)
	
	# Load a test tileset.
	# TODO - refactor to an external class.
	_level_generator.add_level("res://wts//headphones.wtl")
	
	# Build the test tileset.
	_level_generator.build_level()
	
	# Get the level dictionary.
	_level_dictionary = _level_generator.get_level_dictionary()
