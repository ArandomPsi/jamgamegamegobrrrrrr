extends Node2D

var icondown = preload("res://assets/gae/down.svg")
var iconup = preload("res://assets/gae/up.svg")
var down : bool = true

var barthingy : float = 0

func _ready() -> void:
	$Button.text = ""
	
	$joe/eye/eye.frame = patient.eyecondition
	

func _process(delta: float) -> void:
	
	#camera movement
	$Camera2D.offset = lerp($Camera2D.offset,(get_global_mouse_position() - $Camera2D.position)/15,0.1)
	
	armstuff()
	
	

func armstuff():
	if $joe/goonerarm.visible:
		$joe/goonerarm/bar.value = barthingy
		barthingy -= 0.1
		if Input.is_action_just_pressed("mousepress"):
			barthingy += 5
		barthingy = clamp(barthingy,0,patient.bloodpressure)


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
	$gotomouse/thermometer.visible = false
	$gotomouse/stethoscope.visible = false
	$joe/goonerarm.visible = false
	$deskstuff/popsicle.visible = false
	




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


func _on_thermo_pressed() -> void:
	campostween(Vector2(460,150))
	camzoomtween(4)
	$gotomouse/thermometer.visible = true


func _on_stetho_pressed() -> void:
	campostween(Vector2(576,324))
	camzoomtween(1.4)
	$gotomouse/stethoscope.visible = true


func _on_goonerarm_pressed() -> void:
	campostween(Vector2(240,350))
	camzoomtween(5)
	$joe/goonerarm.visible = true


func _on_popsicle_pressed() -> void:
	campostween(Vector2(460,150))
	camzoomtween(4.5)
	$gotomouse/popsicle.visible = true
