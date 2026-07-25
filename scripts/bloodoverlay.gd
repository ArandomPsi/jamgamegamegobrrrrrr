extends Sprite2D
@export var cam : Node2D
func _process(delta: float) -> void:
	global_position = cam.global_position + (cam.offset/1.2)
