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


func _on_button_2_pressed() -> void:
	tutorialin()

func tutorialin():
	var tween = create_tween()
	$tutorialwindow.visible = true
	tween.tween_property($pivot,"scale",Vector2(0.1,0.1),0.6).set_trans(Tween.TRANS_CUBIC)
	tween.parallel().tween_property($pivot,"rotation",TAU,0.6).set_trans(Tween.TRANS_CUBIC)
	tween.parallel().tween_property($pivot2,"scale",Vector2(1,1),0.8).set_trans(Tween.TRANS_CUBIC)
	tween.parallel().tween_property($pivot2,"rotation",TAU,0.8).set_trans(Tween.TRANS_CUBIC)
	tween.parallel().tween_property($tutorialwindow,"position:x",673.0,0.8).set_trans(Tween.TRANS_CUBIC)
	
#

func _on_button_4_pressed() -> void:
	tutorialout()


func tutorialout():
	var tween = create_tween()
	tween.tween_property($pivot2,"scale",Vector2(0.1,0.1),0.6).set_trans(Tween.TRANS_CUBIC)
	tween.parallel().tween_property($pivot2,"rotation",0,0.6).set_trans(Tween.TRANS_CUBIC)
	tween.parallel().tween_property($pivot,"scale",Vector2(1,1),0.8).set_trans(Tween.TRANS_CUBIC)
	tween.parallel().tween_property($pivot,"rotation",0,0.8).set_trans(Tween.TRANS_CUBIC)
	tween.parallel().tween_property($tutorialwindow,"position:x",1185.0,0.8).set_trans(Tween.TRANS_CUBIC)
	await tween.finished
	$tutorialwindow.visible = false
