extends CSGBox

# Builds a floor given a series of floor blocks.

# The distance of which to place each floor.
var x_offset = 1;
var z_offset = 1;

var block_list = [];


# Called when the node enters the scene tree for the first time.
func _ready():
	return;
	# Figure out the size to spawn.
	var x_count = floor(self.width / x_offset);
	var z_count = floor(self.depth / z_offset);
	
	var x_start = self.translation.x - (x_offset * x_count / 2);
	var z_start = self.translation.z - (z_offset * z_count / 2);
	
	for i in x_count:
		for j in z_count:
			# Spawn a block at each coordinate.
			var block = preload("res://nodes/game_nodes/simple_block.tscn").instance();
			self.add_child(block);
			block.translation.x = x_start + (i * x_offset);
			block.translation.z = z_start + (j * z_offset);
			
			block.translate(Vector3(0, -1, 0));
			
			# add this block
			block_list.append(block);
		
	# Hide ourselves; we are no longer necessary.
	# self.visible = true;


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
