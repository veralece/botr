extends Node

var player: CharacterBody3D
func _on_player_player_spawned(spawned_node):
	player = spawned_node
