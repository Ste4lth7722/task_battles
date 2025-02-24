extends Control

@export var control_switch_timer: Label
@export var current_controller_label: Label


func update_switch_timer(new_time: float) -> void:
	var new_text: String = var_to_str(snappedf(new_time, 1)).replace(".0", "")
	control_switch_timer.text = new_text


func update_controller_label(p2_controlling: bool) -> void:
	if not p2_controlling:
		current_controller_label.text = "Player 1 Control"
		current_controller_label.add_theme_color_override("font_color", Color.LIGHT_BLUE)
	elif p2_controlling:
		current_controller_label.text = "Player 2 Control"
		current_controller_label.add_theme_color_override("font_color", Color.LIGHT_CORAL)
