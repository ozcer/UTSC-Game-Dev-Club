
extends Control


func _ready():
	$AnimationPlayer.play("menu_title_anim")


func _on_play_button_pressed():
	# Go to level 1 for now
	get_tree().change_scene("res://levels/level_1/level_1.tscn")


func _on_quit_button_pressed():
	# Exit game
	get_tree().quit()
