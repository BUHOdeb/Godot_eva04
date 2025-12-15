extends Area2D

var active := true

func _on_body_entered(body):
	if not active:
		return

	if body.is_in_group("player"):
		active = false
		GameManager.lose_life()

		# reactiva después de un frame
		call_deferred("_reactivate")

func _reactivate():
	active = true
