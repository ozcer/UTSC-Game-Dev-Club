extends Area2D

signal game_won

func _on_FinishZone_body_entered(body):
	if body.is_in_group("player"):
		emit_signal("game_won")
		body.queue_free()
