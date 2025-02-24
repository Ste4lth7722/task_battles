extends Node3D

#region UI Variable Holders
var multiplayer_connections_ui
var in_game_ui
#endregion

var current_map

func _ready() -> void:
	multiplayer_connections_ui = $CanvasLayer/MultiplayerConnectionsUI


func update_controller_label(p2_controlling: bool) -> void:
	if not in_game_ui == null:
		in_game_ui.update_controller_label(p2_controlling)
	else:
		print("error - reference to in game ui null.")


func start_game():
	current_map = load("res://maps/test_map.tscn").instantiate()
	add_child(current_map)
	in_game_ui = load("res://scenes/ui_scenes/in_game_ui.tscn").instantiate()
	$CanvasLayer.add_child(in_game_ui)
	multiplayer_connections_ui.queue_free()
