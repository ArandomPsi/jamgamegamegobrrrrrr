extends Node2D

var icondown = preload("res://assets/gae/down.svg")
var iconup = preload("res://assets/gae/up.svg")
var down : bool = true
var current_patient : Patient = Patient.new()
var spitcount : int = 0


var barthingy : float = 0
var bprelease : bool = false
const bpbuffer : float = 13.0 * 0.925925926

const eyebuffer : float = 40.3 / 646.0
var playereyebarvel : float = 0.0
const uieyebuffer : float = 23.0
var eyeopenamount : int = 0
var eye_exam_complete : bool = false

var t : float

var screenshake : int = 0

var rushing : bool = false
var usingtool : bool = false
var stressval : float = 0.0
var daynum : int = 1
var patient_requirement : int = 3


var scaling : Dictionary = {
	1: {
		"range": Vector2(90, 120),
		"quota": 3,
		"diseaseoptions": 3
	},
	2: {
		"range": Vector2(90, 120),
		"quota": 5,
		"diseaseoptions": 4
	},
	3: {
		"range": Vector2(75, 100),
		"quota": 6,
		"diseaseoptions": 5
	},
	4: {
		"range": Vector2(75, 100),
		"quota": 7,
		"diseaseoptions": 7
	},
	5: {
		"range": Vector2(65, 90),
		"quota": 9,
		"diseaseoptions": 10
	},
	6: {
		"range": Vector2(50, 75),
		"quota": 10,
		"diseaseoptions": 14
	},
	7: {
		"range": Vector2(45, 60),
		"quota": 12,
		"diseaseoptions": 21
	}
}

var disease_amount : int = 3
var disease_possibilities : Array = []
var cure_possibilities : Array = []
@onready var cure_labels : Array = [
	$clipboard/op1/Label,
	$clipboard/op2/Label,
	$clipboard/op3/Label,
	$clipboard/op4/Label
]
var curenum : int = 0

@onready var daytimethingy  = $otherui/daytimervisual

var circlehits : int = 0


func _ready() -> void:
	$Button.text = ""
	newpatient()
	patient_requirement = scaling[daynum]["quota"]
	disease_amount = scaling[daynum]["diseaseoptions"]
	$otherui/daytimervisual.max_value = $otherui/daytimer.wait_time
	$screen/ecgbutton.modulate *= 2.0
	
	transitionin()
	
	

func _process(delta: float) -> void:
	
	
	t += delta
	#camera movement
	$Camera2D.offset = lerp($Camera2D.offset,(get_global_mouse_position() - $Camera2D.position)/15,0.1) + Vector2(randf_range(-1,1),randf_range(-1,1)) * screenshake
	
	
	
	screenshake -= 1
	screenshake = clamp(screenshake,0,30)
	
	
	if $gotomouse/stethoscope.visible:
		match current_patient.whatstethohears:
			0:
				$sounds/normalbreathing.volume_db = 0.0
			1:
				$sounds/wheezing.volume_db = 20.0
			2:
				$sounds/crackle.volume_db = 10.0
	else:
		$sounds/normalbreathing.volume_db = -80
		$sounds/wheezing.volume_db = -80
		$sounds/crackle.volume_db = -80
	
	var progress = ($otherui/daytimer.wait_time - current_patient.time_left) / $otherui/daytimer.wait_time
	
	#$otherui/daytimervisual.value = $otherui/daytimer.wait_time - $otherui/daytimer.time_left
	
	current_patient.time_left -= delta
	
	if current_patient.time_left < 1:
		ldoctor()
		
	
	$clock/hand.rotation = progress * TAU + PI/4
	
	$otherui/Label.text = "Day " + str(daynum)
	
	$screen/ecgbutton.disabled = global.heartrateshow
	
	armstuff()
	eyestuff(delta)
	stress()
	

func stress():
	stressval -= 0.05
	if rushing:
		stressval += 0.3
	if usingtool:
		stressval += 0.175
	stressval = clamp(stressval, 0.0, 100.0)
	$otherui/stressmeter.value = stressval
	$screeneffects/CanvasModulate.color.r = stressval * 0.002 + 0.694117647
	$bgmusic.pitch_scale = remap(stressval, 0.0, 100.0, 0.85, 1.0)


func armstuff():
	if $joe/goonerarm.visible:
		$joe/goonerarm/bar.value = barthingy
		barthingy -= 0.25
		if Input.is_action_just_pressed("mousepress"):
			barthingy += 5
		barthingy = clamp(barthingy,0,current_patient.bloodpressure)
		

func eyestuff(delta : float):
	if $joe/eye.visible and !eye_exam_complete:
		
		$joe/eye/eyeclipmask.visible = false
		
		$joe/eye.texture = preload("res://assets/eyes/closedeye.svg")
		
		if Input.is_action_just_pressed("mousepress"):
			$joe/eye/hand.shake += 10
			eyeopenamount += 50
		
		
		if eyeopenamount > 200:
			eye_exam_complete = true
			$joe/eye/hand.frame = 1
		
		
	else:
		$joe/eye/eyeclipmask/eye.position = Vector2(sin(t*1.2) * 30,cos(t*1.2)*5)
		$joe/eye/eyeclipmask.visible = true
		$joe/eye.texture = preload("res://assets/eyes/normaleye.svg")
		if eyeopenamount < 10:
			eye_exam_complete = false
			$joe/eye/hand.frame = 0
	
	eyeopenamount = clamp(eyeopenamount,0,300)
	eyeopenamount -= 1
	
	


func _input(event):
	if event.is_action_pressed("esc"):
		resetcam()


func cam_tween(up : bool):
	var end = 324.0 if up else 900.0
	var tween = create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property($Camera2D, "global_position:y", end, 0.4)
	await tween.finished
	
	


func _on_button_pressed() -> void:
	if not $clipboard.visible and not $ipad.visible:
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
	usingtool = false
	rushing = false
	circlehits = 0
	
	
	#make everything not visible
	$joe/eye.visible = false
	$gotomouse/thermometer.visible = false
	$gotomouse/stethoscope.visible = false
	$joe/goonerarm.visible = false
	$gotomouse/popsicle.visible = false
	$gotomouse/magnifyingglass.hide()
	$joe/arms.hide()
	$screen/ecgbutton.disabled = false
	byebyeipad()
	byebyeclipboard()
	await get_tree().process_frame
	for vis in $screen/visuals.get_children():
		vis.queue_free()
	




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
	usingtool = true


func _on_thermo_pressed() -> void:
	campostween(Vector2(460,150))
	camzoomtween(4)
	$gotomouse/thermometer.visible = true
	usingtool = true


func _on_stetho_pressed() -> void:
	campostween(Vector2(576,324))
	camzoomtween(1.4)
	$gotomouse/stethoscope.visible = true
	usingtool = true
	


func _on_goonerarm_pressed() -> void:
	campostween(Vector2(240,350))
	camzoomtween(5)
	$joe/goonerarm.visible = true
	usingtool = true


func _on_popsicle_pressed() -> void:
	spitcount = 0
	campostween(Vector2(460,175))
	camzoomtween(4.5)
	$gotomouse/popsicle.visible = true
	usingtool = true

func _on_magnifyingglass_pressed() -> void:
	campostween(Vector2(275.0, 350.0))
	camzoomtween(4.0)
	$gotomouse/magnifyingglass.show()
	$joe/arms.show()
	usingtool = true

func _on_moutharea_body_entered(body: Node2D) -> void:
	if $gotomouse/popsicle.visible:
		$gotomouse/popsicle/goon.restart()

		screenshake += 8
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
		$gotomouse/popsicle/goon.emitting = false
		#$gotomouse/popsicle/goon/splats.emitting = false
		spitcount += 1
		$joe.frame = 1

func _on_moutharea_area_exited(area : Area2D):
	$joe.frame = 0

func _on_ipad_pressed() -> void:
	campostween(Vector2(1152/2,648/2))
	camzoomtween(1)
	$ipad.visible = true
	var tween = create_tween()
	tween.tween_property($ipad,"position:y",327.0,0.4).set_trans(Tween.TRANS_CUBIC)
	

func byebyeipad():
	var tween = create_tween()
	tween.tween_property($ipad,"position:y",1447.0,0.8).set_trans(Tween.TRANS_CUBIC)
	await tween.finished
	$ipad.visible = false


func _on_clipboard_pressed() -> void:
	campostween(Vector2(1152/2,648/2))
	camzoomtween(1)
	$clipboard.visible = true
	$clipboard.position = Vector2(-11,1180)
	$clipboard.rotation = PI
	var tween = create_tween()
	tween.tween_property($clipboard,"position",Vector2(173,750),0.4).set_trans(Tween.TRANS_CUBIC)
	tween.parallel().tween_property($clipboard,"rotation_degrees",0,0.8).set_trans(Tween.TRANS_CUBIC)

func byebyeclipboard():
	var tween = create_tween()
	tween.tween_property($clipboard,"position",Vector2(173,800),0.6).set_trans(Tween.TRANS_CUBIC)
	tween.parallel().tween_property($clipboard,"rotation_degrees",180,0.6).set_trans(Tween.TRANS_CUBIC)
	await tween.finished
	$clipboard.visible = false

func armssetup():
	var val : int = current_patient.ARMS.values()[current_patient.armcondition]
	match val:
		0: # normal
			$joe/arms/leftarm/actual.modulate = Color.WHITE
			$joe/arms/rightarm/actual.modulate = Color.WHITE
		1: # rash
			$joe/arms/leftarm/actual.modulate = Color.WHITE
			$joe/arms/rightarm/actual.modulate = Color.WHITE
			for arm in $joe/arms.get_children():
				for i in range(randi_range(2, 5)):
					var rash = Sprite2D.new()
					rash.texture = load("res://assets/gae/rashpatch.png")
					var point = randf_range(0.0, 1.0)
					arm.get_child(1).add_child(rash)
					rash.rotation_degrees = randf_range(0.0, 360.0)
					var pathf = arm.find_children("*", "PathFollow2D", true, true).front()
					pathf.progress_ratio = point
					rash.global_position = pathf.global_position
					rash.scale = Vector2.ONE * 0.16 * randf_range(0.35, 0.5) * (point + 0.1)
					rash.use_parent_material = true
					rash.light_mask = arm.light_mask
					rash.z_index = 1
					rash.modulate = Color(0.5,0.5,0.5)
					
		2: # cold
			$joe/arms/leftarm/actual.modulate = Color("9301ec")
			$joe/arms/rightarm/actual.modulate = Color("9301ec")
		3: # hot
			$joe/arms/leftarm/actual.modulate = Color("#c80400")
			$joe/arms/rightarm/actual.modulate = Color("#c80400")
		4:
			$joe/arms/leftarm/actual.modulate = Color.WHITE
			$joe/arms/rightarm/actual.modulate = Color.WHITE
			for arm in $joe/arms.get_children():
				for i in range(randi_range(2, 5)):
					var fungal = Sprite2D.new()
					fungal.texture = load("res://assets/gae/fungalpatch.svg")
					var point = randf_range(0.0, 1.0)
					arm.get_child(1).add_child(fungal)
					fungal.rotation_degrees = randf_range(0.0, 360.0)
					var pathf = arm.find_children("*", "PathFollow2D", true, true).front()
					pathf.progress_ratio = point
					fungal.global_position = pathf.global_position
					fungal.scale = Vector2.ONE * min(point + 0.25, 1)
					fungal.use_parent_material = true
					fungal.light_mask = arm.light_mask
					fungal.z_index = 1
					fungal.modulate = Color(0.5,0.5,0.5)
	


func _on_op_1_pressed() -> void:
	if curenum == 0:
		correctdiagnosis()
	else:
		ldoctor()


func _on_op_2_pressed() -> void:
	if curenum == 1:
		correctdiagnosis()
	else:
		ldoctor()


func _on_op_3_pressed() -> void:
	if curenum == 2:
		correctdiagnosis()
	else:
		ldoctor()


func _on_op_4_pressed() -> void:
	if curenum == 3:
		correctdiagnosis()
	else:
		ldoctor()


func correctdiagnosis():
	resetcam()
	$results/resul.text = "correct diagnosis \n the patient survived"
	$results/resul.modulate.a = 0
	$results.visible = true
	$results.modulate.a = 0
	var tween = create_tween()
	tween.tween_property($results,"modulate:a",1.0,0.9)
	tween.tween_property($results/resul,"modulate:a",0.5,0.7).set_delay(0.8)
	tween.tween_interval(4)
	await tween.finished
	
	newpatient()
	

func ldoctor():
	resetcam()
	current_patient.died.emit()
	$results/resul.text = "L doctor \n the patient fricking died you bum"
	$results/resul.modulate.a = 0
	$results.visible = true
	$results.modulate.a = 0
	$results/ldoctor.visible = true
	var tween = create_tween()
	tween.tween_property($results,"modulate:a",1.0,0.9)
	tween.tween_property($results/resul,"modulate:a",0.5,0.7).set_delay(0.8)
	tween.tween_interval(4)
	await tween.finished
	
	newpatient()
	



func newpatient():
	
	#other stuff
#	current_patient = Patient.new()
	current_patient.newpatient()
	current_patient.time_left = randi_range(scaling[daynum]["range"].x, scaling[daynum]["range"].y)
	disease_possibilities.clear()
	cure_possibilities.clear()
	disease_possibilities.append(current_patient.DISEASE.keys()[current_patient.disease])
	for i in range(disease_amount - 1):
		var ops = current_patient.DISEASE.keys().duplicate()
		for d in disease_possibilities:
			ops.erase(d)
		disease_possibilities.append(ops.pick_random())
	cure_possibilities.append(current_patient.curename)
	for d in disease_possibilities:
		var di = current_patient.DISEASE.get(d)
		for c in current_patient.cures:
			if di in current_patient.cures[c]:
				if not c in cure_possibilities:
					cure_possibilities.append(c)
					print(c)
	for i in range(3):
		var ops = current_patient.cures.keys().duplicate()
		for c in cure_possibilities:
			ops.erase(c)
		cure_possibilities.append(ops.pick_random())
	for i in range(randi_range(0, 5)):
		disease_possibilities.shuffle()
		cure_possibilities.shuffle()
	curenum = cure_possibilities.find(current_patient.curename)
	for i in range(cure_labels.size()):
		cure_labels[i].text = cure_possibilities[i]
	
	
	global.heartrateshow = false
	$joe/eye/eyeclipmask/eye.frame = current_patient.eyecondition
	$gotomouse/popsicle/goon.restart()
	$gotomouse/popsicle/goon.emitting = false
	$gotomouse/popsicle/goon/splats.emitting = false
	for overlay in $joe/arms/leftarm/actual.get_children():
		overlay.queue_free()
	armssetup()
	$ipad.regenerate(disease_possibilities)
	for lbl in cure_labels:
		lbl.get_parent().get_node("check").frame = 0
	#animations
	var tween = create_tween()
	tween.tween_property($results,"modulate:a",0.0,0.9)
	await tween.finished
	$results.visible = false


func _on_ecgbutton_pressed() -> void:
	camzoomtween(1.35)
	$screen/ecgbutton.disabled = true
	generate_hit_circle()

func generate_hit_circle():
	var newhitcircle = preload("res://scenes/ecgcircle.tscn").instantiate()
	$screen.add_child(newhitcircle)
	newhitcircle.scale = Vector2.ONE * 0.32
	newhitcircle.position.x = randf_range($screen/startmark.position.x, $screen/endmark.position.x)
	newhitcircle.position.y = randf_range($screen/endmark.position.y, $screen/startmark.position.y)
	newhitcircle.hit_success.connect(hit_circle_check.bind(true))
	newhitcircle.hit_failed.connect(hit_circle_check.bind(false))

func transitionin():
	var tween = create_tween()
	$Camera2D.zoom = Vector2(1,1) * 5
	tween.tween_property($screeneffects/fade,"modulate:a",0.0,0.8)
	tween.parallel().tween_property($Camera2D, "zoom",Vector2(1,1),0.7).set_trans(Tween.TRANS_CUBIC)
	await tween.finished
	$screeneffects/fade.visible = false

func hit_circle_check(good : bool):
	if good:
		circlehits += 1
		if circlehits >= 4:
			global.heartrateshow = true
			
			resetcam()
		else:
			generate_hit_circle()
	else:
		resetcam()
