extends Node


"""
The LevelManager is the highest-order node for running and creating a level.
It is the interface for any object to interact with whenever a level is to be made.

A Level is a high-order scene node that generates an entire level within it.
"""

# Create the helper nodes for the LevelManager.
var _levelGenerator = null
var _level = null


func _ready():
	# Create our LevelGenerator node.
	self._levelGenerator = preload("res://level/LevelGenerator.tscn").instance()
	self.add_child(_levelGenerator)
	
	# Load a test tileset.
	# TODO - refactor to an external class.
	self._level = preload("res://level/templates/Level_Headphones.tscn").instance()
	self._levelGenerator.add_level(self._level)
	
	# Build the test tileset.
	self._levelGenerator.build_level()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
