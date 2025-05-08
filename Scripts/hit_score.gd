extends Node2D

func _ready():
	var pos_tween = get_tree().create_tween()
	var mod_tween = get_tree().create_tween()
	
	var final_pos = global_position + Vector2(0,-50)
	pos_tween.tween_property($".", "global_position", final_pos, 0.4)
	
	var final_color = Color("ffffff00")
	pos_tween.tween_property($".", "modulate", final_color, 0.4)
