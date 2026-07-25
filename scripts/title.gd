extends Control

func _process(delta: float) -> void:
	$pivot.rotation_degrees += 6 * delta
