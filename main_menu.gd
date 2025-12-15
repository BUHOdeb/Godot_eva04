extends Control

@export var first_level: String = "res://nivel_1.tscn"

func _on_play_pressed():
	get_tree().change_scene_to_file(first_level)

func _on_exit_pressed():
	get_tree().quit()
