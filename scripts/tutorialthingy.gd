extends Label

@export var attachedbutton : Button



func _process(delta: float) -> void:
	if visible:
		if attachedbutton.is_hovered():
			modulate.a = lerp(modulate.a,1.0,0.2)
		else:
			modulate.a = lerp(modulate.a,0.0,0.2)
	else:
		modulate.a = 0.0
