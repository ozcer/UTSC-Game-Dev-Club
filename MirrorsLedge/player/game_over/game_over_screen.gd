extends Control





func _on_return_button_pressed():
	get_tree().change_scene("res://menu/menu.tscn")


func _on_FinishZone_game_won():
	$".".show()
