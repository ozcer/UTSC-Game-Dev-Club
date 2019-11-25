extends Node2D

var Bleeper = preload("res://Bleep.tscn")
var Blooper = preload("res://Bloop.tscn")
var BoostPad = preload("res://Boost.tscn")

var score = 0
var enemySpeed = 0
var enemyPositionX = 520

signal newPhase

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	get_node("CanvasLayer/Score").text = str(score)
	
func _input(event):
	if event is InputEventKey and event.pressed:
		if event.scancode >= 48 and event.scancode <= 53:
			score = (event.scancode - 48) * 10 - 1
			_on_pass_enemy()

func _on_SpawnTimer_timeout():
	var enemy
	var enemyType = randi() % 2
	if enemyType == 0:
		enemy = Bleeper.instance()
		enemy.position.y = 422
		enemy.scale.x = -1
	else:
		enemy = Blooper.instance()
		enemy.position.y = 350
	enemy.position.x = enemyPositionX
	enemy.speed = 300 + enemySpeed*15
	enemy.phaseFive = score >= 50
	enemy.name = "Enemy"
	add_child(enemy)
	enemy.connect("defeat", self, "_on_pass_enemy")
	get_node("SpawnTimer").start(0.8 - (0.1 * enemySpeed) + 0.2 * (randi() % 5))

func _on_pass_enemy():
	score += 1
	if score <= 50 and score % 10 == 0:
		get_node("SpawnTimer").stop()
		enemySpeed = score / 10
		var boostPad = BoostPad.instance()
		boostPad.name = "Boost"
		boostPad.position.x = 1152
		boostPad.position.y = 456
		add_child(boostPad)
		if score < 50:
			boostPad.connect("end_boost", self, "_on_end_boost")
		else:
			_on_end_boost()

	get_node("CanvasLayer/Score").text = str(score)

func _on_end_boost():
	get_node("Level").frame = (score / 10)
	#emit_signal(phaseSignals[(score / 10)-1])
	emit_signal("newPhase", score / 10)
	get_node("SpawnTimer").start(0.8 - (0.1 * enemySpeed) + 0.2 * (randi() % 5))

func _on_pauseGame():
	get_tree().paused = true
	get_node("CanvasLayer/PauseScreen").visible = true
	
func _on_Restart_pressed():
	get_node("CanvasLayer/PauseScreen").visible = false
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_Resume_pressed():
	get_node("CanvasLayer/PauseScreen").visible = false
	get_tree().paused = false

func _on_newPhase(num):
	if num >= 4:
		enemyPositionX = 370
	else:
		enemyPositionX = 520
	if num >= 5:
		get_node("PowerUp").play()