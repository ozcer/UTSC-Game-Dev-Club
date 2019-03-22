extends Area2D



func _on_spike_area_body_entered(body):
	if body.is_in_group("player"):
		print("player died!")
		body.queue_free()
