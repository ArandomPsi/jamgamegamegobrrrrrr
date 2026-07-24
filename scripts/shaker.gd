extends AnimatedSprite2D

var shake : int = 0
func _process(delta: float) -> void:
	shake -= 1
	shake = clampi(shake,0,50)
	offset = Vector2(randf_range(-1,1),randf_range(-1,1)) * shake
