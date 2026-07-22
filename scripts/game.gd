extends Node2D

var down : bool = true

func cam_tween(up : bool):
	var end = 324.0 if up else 973.0
	var tween = create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property($Camera2D, "global_position:y", end, 0.75)
	await tween.finished


func _on_button_pressed() -> void:
	cam_tween(not down)
	down = not down
