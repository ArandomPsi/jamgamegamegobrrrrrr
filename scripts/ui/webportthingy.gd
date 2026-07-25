extends Control
func _ready() -> void:
	var tween = create_tween()
	tween.tween_interval(5)
	tween.tween_property($Label,"modulate",Color("b00000"),4)
	tween.tween_property($Label,"modulate",Color(0.0, 0.0, 0.0),4)
	
	await tween.finished
	get_tree().change_scene_to_file("res://scenes/title.tscn")
