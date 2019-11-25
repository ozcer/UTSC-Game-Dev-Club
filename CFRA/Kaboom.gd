extends Sprite

export var speed = 250

func _ready():
	get_node("AnimationPlayer").play("Boom")

func _process(delta):
	position.x -= speed * delta
	if position.x < -16:
		free()