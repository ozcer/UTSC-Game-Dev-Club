extends Sprite

func _ready():
	pass

func _on_phaseFour():
	get_node("Tween").interpolate_property(self, "position:x", -512, 0, 0.35, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	get_node("Tween").start()