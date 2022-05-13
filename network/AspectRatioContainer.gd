extends AspectRatioContainer


func _process(delta):
	set_ratio(get_viewport().size.x / get_viewport().size.y)
