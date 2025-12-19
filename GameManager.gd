extends Node


# estado global

var lives := 3
var coins := 0
var current_level := 1

var last_checkpoint: Vector2
var player: CharacterBody2D

@export var coins_to_win := 2
@export var level_1_path := "res://nivel_1.tscn"
@export var level_2_path := "res://nivel_2.tscn"
@export var congratulations_path := "res://congratulations.tscn"

signal hud_updated


# hud y estado

func start_game():
	lives = 3
	coins = 0
	current_level = 1
	player = null
	last_checkpoint = Vector2.ZERO
	emit_signal("hud_updated")

func register_player(p: CharacterBody2D):
	player = p
	last_checkpoint = p.global_position

func update_checkpoint():
	if player:
		last_checkpoint = player.global_position


# monedas

func add_coin():
	coins += 1
	update_checkpoint()
	emit_signal("hud_updated")

	if coins >= coins_to_win:
		coins = 0
		advance_level()


# vidas

func lose_life():
	lives -= 1
	emit_signal("hud_updated")

	if lives <= 0:
		get_tree().change_scene_to_file("res://game_over.tscn")
	else:
		call_deferred("respawn")

func respawn():
	if player:
		player.global_position = last_checkpoint
		player.velocity = Vector2.ZERO


# niveles
func advance_level():
	current_level += 1

	if current_level == 2:
		get_tree().change_scene_to_file(level_2_path)
	else:
		get_tree().change_scene_to_file(congratulations_path)

func reset_level():
	lives = 3
	coins = 0
	emit_signal("hud_updated")
#
