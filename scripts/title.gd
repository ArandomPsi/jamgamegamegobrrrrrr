extends Control

var t : float
var shake : int = 0

@export var heartscalegraph : Curve

func _process(delta: float) -> void:
	t += delta
	
	var x = fmod(t, 1.0)
	var amount = heartscalegraph.sample(x)
	if amount > 0.8:
		shake = 4
	
	$heart.material.set_shader_parameter("amount",amount * 20)
	
	shake -= 1
	shake = clamp(shake,0,20)
	
	
	$Camera2D.offset = lerp($Camera2D.offset,Vector2(randf_range(-1,1),randf_range(-1,1)) * shake * 4,0.2)
	
	
	

func transition():
	$fade.visible = true
	var tween = create_tween()
	tween.tween_property($Camera2D,"zoom",Vector2(0.5,0.5),0.8).set_trans(Tween.TRANS_CUBIC)
	tween.parallel().tween_property($fade,"modulate:a",1.0,0.5)
	await tween.finished
	get_tree().change_scene_to_file("res://scenes/game.tscn")
	
	


func _on_button_pressed() -> void:
	transition()
