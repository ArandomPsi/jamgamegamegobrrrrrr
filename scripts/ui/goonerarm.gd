extends Button
var basey : float
func _ready() -> void:
	basey = $Sprite2D.position.y 
func _process(delta: float) -> void:
	if is_hovered():
		$Sprite2D.position.y = lerpf($Sprite2D.position.y,basey - 60,0.2)
		$Label.visible = true
	else:
		$Sprite2D.position.y = lerpf($Sprite2D.position.y,basey,0.2)
		$Label.visible = false
