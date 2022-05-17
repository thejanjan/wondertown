extends Sprite3D

"""
Builds a sky texture plane across the background.
"""

var radius = 7  # must be odd


func _ready():
	# Build new texture planes.
	var world_size = tex_size_to_world_dist()
	
	for i in range((radius * 2) + 1):
		for j in range((radius * 2) + 1):
			if (i == radius) && (i == j):
				continue
			
			# create new texture plane
			var tex_plane = Sprite3D.new()
			tex_plane.texture = texture
			
			# get the i, j offset of this plane
			var x_scale = i - radius
			var y_scale = j - radius
			
			# move this plane relative to us
			add_child(tex_plane)
			var pos_offset = Vector3(
				world_size.x * x_scale,
				world_size.y * y_scale,
				0
			)
			tex_plane.translate(pos_offset)
	

func tex_size_to_world_dist():
	"""
	Given the texture size of this Sprite3D,
	calculates the size of the texture in the world.
	"""
	return Vector2(
		texture.get_width()  * pixel_size,
		texture.get_height() * pixel_size
	)
