extends Node2D

var icondown = preload("res://assets/gae/down.svg")
var iconup = preload("res://assets/gae/up.svg")
var down : bool = true

func _ready() -> void:
	$Button.text = ""

func _input(event):
	if event.is_action_pressed("esc"):
		resetcam()


func cam_tween(up : bool):
	var end = 324.0 if up else 900.0
	var tween = create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property($Camera2D, "global_position:y", end, 0.4)
	await tween.finished
	
	


func _on_button_pressed() -> void:
	cam_tween(not down)
	down = not down
	if down: downarrow()
	else:uparrow()


func uparrow():
	$Button.icon = iconup

func downarrow():
	$Button.icon = icondown

func resetcam():
	campostween(Vector2(575.0,324))
	camzoomtween(1)
	down = true
	if down: downarrow()
	else:uparrow()
	
	
	#make everything not visible
	$joe/eye.visible = false




func camzoomtween(val : float):
	var tween = create_tween()
	tween.tween_property($Camera2D,"zoom",Vector2(1,1)*val,0.2).set_trans(Tween.TRANS_CUBIC)

func campostween(pos : Vector2):
	var tween = create_tween()
	tween.tween_property($Camera2D,"position",pos,0.2).set_trans(Tween.TRANS_CUBIC)


func _on_light_pressed() -> void:
	campostween(Vector2(410,160))
	camzoomtween(8)
	$joe/eye.visible = true
