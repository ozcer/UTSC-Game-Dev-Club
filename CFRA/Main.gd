extends Node2D

var Bleeper = preload("res://Bleep.tscn")
var Blooper = preload("res://Bloop.tscn")
var BoostPad = preload("res://Boost.tscn")

var score = 0
var enemySpeed = 0
var enemyPositionX = 520

signal phaseOne
signal phaseTwo
signal phaseThree
signal phaseFour
signal phaseFive
var phaseSignals = ["phaseOne", "phaseTwo", "phaseThree", "phaseFour", "phaseFive"]

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	get_node("CanvasLayer/Score").text = str(score)

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
	add_child(enemy)
	enemy.connect("defeat", self, "_on_pass_enemy")
	get_node("SpawnTimer").start(0.8 - (0.1 * enemySpeed) + 0.2 * (randi() % 5))

func _on_pass_enemy():
	score += 1
	if score <= 50 and score % 10 == 0:
		get_node("SpawnTimer").stop()
		enemySpeed += 1
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
	emit_signal(phaseSignals[(score / 10)-1])
	get_node("SpawnTimer").start(0.8 - (0.1 * enemySpeed) + 0.2 * (randi() % 5))

func _on_phaseFour():
	enemyPositionX = 370

func _on_phaseFive():
	get_node("PowerUp").play()
