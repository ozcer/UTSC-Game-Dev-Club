extends AudioStreamPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	if volume_db < -10:
		volume_db += delta

func _on_phaseTwo():
	volume_db = -10
