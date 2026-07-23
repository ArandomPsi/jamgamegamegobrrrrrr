extends TextureProgressBar

func _ready() -> void:
	value = 0

func goup(val:float = 100):
	value = 0
	var tween = create_tween()
	tween.tween_property(self,"value",val,0.8).set_trans(Tween.TRANS_CUBIC)


func _on_area_2d_area_entered(area: Area2D) -> void:
	goup(40)
	


func _on_area_2d_area_exited(area: Area2D) -> void:
	goup(0)
