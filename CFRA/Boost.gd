extends Area2D

var speed = 1280
signal end_boost

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _process(delta):
	position.x -= speed * delta
	if position.x < -256:
		emit_signal("end_boost")
		free()