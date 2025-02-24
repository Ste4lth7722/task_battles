extends Node3D

@export_custom(PROPERTY_HINT_NONE, "suffix:s") var switch_timer_initial: int = 10

@onready var game: Node3D = $".."
@onready var player: CharacterBody3D = $Player

var timer_running: bool = true
var current_switch_timer: float = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_switch_timer = switch_timer_initial


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if timer_running:
		lower_switch_timer(delta)
	print(GameManager.p1_unique_id)
	print(GameManager.p2_unique_id)


func lower_switch_timer(delta: float) -> void:
	current_switch_timer -= delta
	game.in_game_ui.update_switch_timer(current_switch_timer)
	
	if current_switch_timer <= 0:
		current_switch_timer = switch_timer_initial
		player.switch_player_control()
