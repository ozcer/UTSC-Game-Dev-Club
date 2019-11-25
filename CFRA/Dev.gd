extends Label

signal devMode

func _ready():
	pass # Replace with function body.

func _process(delta):
	if Input.is_action_just_pressed("dev"):
		get_node("../PauseScreen/Resume").visible = not(visible)
		visible = not(visible)
		emit_signal("devMode")