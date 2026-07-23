extends Node2D

var icondown = preload("res://assets/gae/down.svg")
var iconup = preload("res://assets/gae/up.svg")
var down : bool = true
var current_patient : Patient = Patient.new()
var spitcount : int = 0


var barthingy : float = 0
var bprelease : bool = false
const bpbuffer : float = 13.0 * 0.925925926

func _ready() -> void:
	$Button.text = ""
	current_patient.newpatient()
	$joe/eye/eye.frame = current_patient.eyecondition
	

func _process(delta: float) -> void:
	
	#camera movement
	$Camera2D.offset = lerp($Camera2D.offset,(get_global_mouse_position() - $Camera2D.position)/15,0.1)
	
	armstuff()
	
	

func armstuff():
	if $joe/goonerarm.visible:
		$joe/goonerarm/bar.value = barthingy
		barthingy -= 0.1 if !bprelease else 0.5
		$joe/goonerarm/bar/hitevents.visible = bprelease
		if !bprelease:
			if Input.is_action_just_pressed("mousepress"):
				barthingy += 5
			if barthingy >= float(current_patient.bloodpressure) - 4.9:
				bprelease = true
				for i in range(3):
					var val = remap(barthingy, 0.0, 100.0, 108.0, 0.0)
					var timing = $joe/goonerarm/bar/hitevents.get_child(i)
					timing.show()
					timing.position.y = (i + 1) * randf_range(13.0, 20.0) + val * (1/0.925925926)
					timing.position.y = clamp(timing.position.y, val * (1/0.925925926), 108.0 - bpbuffer)
		else:
			if Input.is_action_just_pressed("mousepress"):
				for timing in $joe/goonerarm/bar/hitevents.get_children():
					var val = remap(barthingy, 0.0, 100.0, 108.0, 0.0)
					if val >= timing.position.y and val <= timing.position.y + bpbuffer:
						timing.hide()
			if barthingy <= 0.0:
				for i in range(3):
					if $joe/goonerarm/bar/hitevents.get_child(i).visible:
						break
					if i == 2:
						# give player the info or something function?
						pass
				bprelease = false
		barthingy = clamp(barthingy,0,current_patient.bloodpressure)
		


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
	$gotomouse/popsicle.visible = false
	




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
	spitcount = 0
	campostween(Vector2(460,150))
	camzoomtween(4.5)
	$gotomouse/popsicle.visible = true


func _on_moutharea_body_entered(body: Node2D) -> void:
	$gotomouse/popsicle/goon.restart()
	if spitcount > 5:
		
		#set color of mouth
		match current_patient.saliavacolor:
			0:
				$gotomouse/popsicle/goon.modulate = Color("ffffffa0")
			_:
				$gotomouse/popsicle/goon.modulate = Color("40ff00a0")
			2:
				$gotomouse/popsicle/goon.modulate = Color("ffffff")
		
		#make everything emmit
		$gotomouse/popsicle/goon.emitting = true
		$gotomouse/popsicle/goon/splats.emitting = true
		$gotomouse/popsicle/goon.speed_scale = 1.0
		for i in range(5):
			await get_tree().process_frame
		$gotomouse/popsicle/goon.speed_scale = 0.0
	else:
		
		#nah
		$gotomouse/popsicle/goon.restart()
		$gotomouse/popsicle/goon.emitting = false
		$gotomouse/popsicle/goon/splats.emitting = false
		spitcount += 1
