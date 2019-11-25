extends Area2D

export var speed = 250
export var phaseFive = false

var kaboom = preload("res://Kaboom.tscn")

signal defeat

# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("AnimationPlayer").play("Peck")

func _process(delta):
	position.x -= speed * delta
	if position.x < -32:
		emit_signal("defeat")
		free()

func _on_area_entered(area):
	if phaseFive:
		emit_signal("defeat")
		var explosion = kaboom.instance()
		explosion.position.x = position.x
		explosion.position.y = position.y
		get_parent().add_child(explosion)
		queue_free()
