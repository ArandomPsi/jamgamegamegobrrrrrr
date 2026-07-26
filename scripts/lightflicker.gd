extends PointLight2D



func _on_timer_timeout() -> void:
	$buzz.volume_db = -80.0
	$buzz.pitch_scale = randf_range(0.6, 1.5)
	hide()
	for i in range(randi_range(1, 2)):
		await get_tree().create_timer(0.25).timeout
		show()
		$buzz.volume_db = 0.0
		await get_tree().create_timer(0.1).timeout
		hide()
		$buzz.volume_db = -80.0
	await get_tree().create_timer(1.0).timeout
	show()
	$buzz.volume_db = -10.0
	$buzz.pitch_scale = 1.0
