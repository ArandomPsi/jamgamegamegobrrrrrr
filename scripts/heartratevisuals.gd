extends Line2D

var heartrate : int
var graph : Curve = Curve.new()
var pointnum : int = 0
var delay : bool = false

var spike_positions: Array[float]
var last_spike = -1
var nextspike = 0

@export var beep : AudioStreamPlayer2D

func _ready() -> void:
	randomize()
	var curpatient = get_tree().current_scene.current_patient
	await curpatient.setup_finished
	await get_tree().process_frame
	curpatient = get_tree().current_scene.current_patient
	heartrate = curpatient.heartrate * 1.2
	graph.min_domain = -88.5
	graph.max_domain = 88.5
	graph.min_value = -250.0
	graph.max_value = 250.0
	var space = (graph.get_domain_range() - 15.06 * 3) / 4
	var amt = curpatient.heartcondition + 1
	for i in range(amt):
		space += randi_range(-21, 75) / amt
		var startx = (i + 1) * space + graph.min_domain
		var endx = startx + 15.06
		graph.add_point(Vector2(startx, graph.min_value))
		graph.add_point(Vector2((startx + endx) / 2, graph.max_value))
		graph.add_point(Vector2(endx, graph.min_value))
		
		var spike_x = startx + 7.53
		spike_positions.append(spike_x)
	

func _process(delta: float) -> void:
	pointnum += int(300 * delta)
	
	if pointnum > graph.get_domain_range():
		pointnum = 1
		nextspike = 0
		last_spike = -1
		delay = !delay
	
	if !delay:
		var graph_x = pointnum + graph.min_domain
		
		
		#sounds
		for i in spike_positions.size():
			if nextspike < spike_positions.size() and graph_x >= spike_positions[nextspike]:
				last_spike = i
				beep.play()
				nextspike += 1
		
		clear_points()
		
		for i in range(pointnum):
			var x = i + graph.min_domain
			var y = (-graph.sample(x) / 8) + (93.5 * 1.8) + graph.min_value
		
			if y < -78.0:
				y -= heartrate / 1.5
		
			add_point(Vector2(x, y))
