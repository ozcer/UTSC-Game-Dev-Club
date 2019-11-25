extends Camera2D

#.35, .35, 179.2, 380

var shake_severity = 0
var screen_shake = 0

var offsets = Vector2(0, 0)
var transition_time = 0.35

func zoom_in():
    transition_camera(Vector2(.35, .35), Vector2(-76.8, 30))

func transition_camera(new_zoom, new_offset):
	offsets = new_offset
	$Tween.interpolate_property(self, "zoom", get_zoom(), new_zoom, transition_time, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.interpolate_property(self, "offset", get_offset(), new_offset, transition_time, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _process(delta):
	offset.x -= shake_severity * screen_shake
	offset.y += shake_severity * screen_shake
	shake_severity *= -1

func _on_playerJump():
	offset.x += shake_severity / 2
	offset.y -= shake_severity / 2
	screen_shake = 1
	get_node("Shake").start()

func _on_Shake_timeout():
	screen_shake = 0
	offset = offsets

func _on_phaseOne():
	shake_severity = 3

func _on_phaseFour():
	print("yesy")
	zoom_in()