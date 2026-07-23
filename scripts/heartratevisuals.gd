extends Line2D

var heartrate : int
var graph : Curve = Curve.new()
var pointnum : int = 0
var delay : bool = false

func _ready() -> void:
	randomize()
	var curpatient = get_tree().current_scene.current_patient
	await curpatient.setup_finished
	curpatient = get_tree().current_scene.current_patient
	heartrate = curpatient.heartrate
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
		

func _process(delta: float) -> void:
	pointnum += int(300 * delta)
	if pointnum > graph.get_domain_range():
		pointnum = 1
		delay = !delay
	if !delay:
		clear_points()
		for i in range(pointnum):
			var x = i + graph.min_domain
			var y = (-graph.sample(x) / 8) + (93.5 * 1.8) + graph.min_value
			if y < -78.0:
				y -= heartrate / 1.5
			add_point(Vector2(x, y))
