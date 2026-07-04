extends Node2D

@onready var name_input = $NameInput
@onready var name_label = $NameLabel

func _on_PlayButton_pressed():
	var player_name = name_input.text.strip_edges()
	if player_name == "":
		name_label.text = "Please enter a name"
		return
	
	Global.player_name = player_name
	var game_scene = load("res://game.tscn") as PackedScene
	get_tree().change_scene_to_packed(game_scene)
