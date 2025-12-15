extends Control

@export var first_level_path := "res://nivel_1.tscn"

func _on_retry_pressed():
	GameManager.start_game()

func _on_exit_pressed():
	get_tree().quit()
