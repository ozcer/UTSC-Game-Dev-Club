extends AudioStreamPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	if volume_db < -10:
		volume_db += delta

func _on_newPhase(num):
	if num >= 2:
		volume_db = -10
	elif num == 1:
		volume_db = -50
	elif num == 0:
		volume_db = -60
