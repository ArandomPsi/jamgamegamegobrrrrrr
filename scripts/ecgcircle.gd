extends Button

signal hit_success()
signal hit_failed()

func _ready() -> void:
	$player.scale *= randf_range(0.95, 1.5)

func _process(delta: float) -> void:
	$player.scale -= Vector2.ONE * 0.0175
	if $player.scale.x <= 0.0:
		hit_failed.emit()
		queue_free()

func new_ecg_visual():
	var ecg_visual = Sprite2D.new()
	ecg_visual.texture = preload("res://assets/gae/ecgcircle.svg")
	get_parent().get_node("visuals").add_child(ecg_visual)
	ecg_visual.position = position
	ecg_visual.modulate = Color("#b2fffe")
	ecg_visual.light_mask = 1
	ecg_visual.scale = scale / 2


func _on_pressed() -> void:
	if $player.scale.x <= 0.8 and $player.scale.x >= 0.525:
		hit_success.emit()
		new_ecg_visual()
		queue_free()
	else:
		hit_failed.emit()
		queue_free()
