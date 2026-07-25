extends Button


func _process(delta: float) -> void:
	if is_hovered():
		size.x = lerpf(size.x,400,0.2)
	else:
		size.x = lerpf(size.x,360,0.2)
	
	
	
