extends Sprite

func _ready():
	pass

func _on_newPhase(num):
	if num >= 4:
		get_node("Tween").interpolate_property(self, "position:x", position.x, 0, 0.35, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		get_node("Tween").start()
	else:
		get_node("Tween").interpolate_property(self, "position:x", position.x, -512, 0.35, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		get_node("Tween").start()
