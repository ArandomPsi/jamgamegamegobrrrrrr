extends Node2D

var prevpos : Vector2

func _process(delta: float) -> void:
	prevpos = position
	position = lerp(position,get_global_mouse_position(),0.2)
	rotation_degrees = (position.x-prevpos.x)*2
