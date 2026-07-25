extends Control

var wavelength : float = 1502.0 * 10
var t : float = 0.0

func _process(delta: float) -> void:
	
	t += delta * 1.5
	$Line2D.clear_points()
	for i in range(wavelength):
		var x = i
		var y = sin(x * 0.003 - t) * 20
		$Line2D.add_point(Vector2(x, y))
	
	
