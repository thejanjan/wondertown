extends Node


"""
The LevelManager is the highest-order node for running and creating a level.
It is the interface for any object to interact with whenever a level is to be made.

A Level is a high-order scene node that generates an entire level within it.
"""

# Create the helper nodes for the LevelManager.
var _levelGenerator = null


func _ready():
	# Create our LevelGenerator node.
	self.add_child(preload("res://level/LevelGenerator.tscn").instance())


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
