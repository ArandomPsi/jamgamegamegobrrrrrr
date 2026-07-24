extends Button
var checked : bool = false

func _on_pressed() -> void:
	checked = not checked
	if checked:
		$check.frame = 1
	else:
		$check.frame = 0
