extends HBoxContainer

var num : int = 0
var splatting : bool = false

func _process(delta: float) -> void:
	for heart in get_children():
		heart.scale = lerp(heart.scale, Vector2.ONE, 7 * delta)

func _on_timer_timeout() -> void:
	if splatting: return
	if num > get_children().size() - 1:
		num = 0
	get_child(num).scale *= 1.5
	await get_tree().create_timer(0.15).timeout
	if splatting: return
	get_child(num).scale *= 1.25
	num += 1
	if num > get_children().size() - 1:
		num = 0


func _on_visibility_changed() -> void:
	if visible:
		await $"../Timer".timeout
		splatting = true
		for i in range(3):
			get_child(0).scale *= 2.0
			for j in range(int(60 * 0.35)):
				await get_tree().process_frame
		var splat = TextureRect.new()
		splat.texture = preload("res://assets/gae/splat.svg")
		get_child(0).queue_free()
		add_child(splat)
		move_child(splat, 0)
		await get_tree().process_frame
		splat.rotation_degrees = randf_range(0.0, 360.0)
		splat.scale *= randf_range(1.25, 2.0)
		var tween = create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
		tween.tween_property(splat, "modulate:a", 0.0, 1.5).set_delay(0.5)
		await tween.finished
		splat.queue_free()
		splatting = false
