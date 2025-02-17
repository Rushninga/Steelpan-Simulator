extends Control
signal menu_option_select
# respective data transimitted when menu_option_select when one of the buttons are pressed
# play = _on_play_pressed():
# create = _on_create_pressed():
# how = _on_how_to_play_pressed():
# log out = _on_log_out_pressed():

func _on_play_pressed():
	get_parent().switch_screen("song select")


func _on_create_pressed():
	get_parent().switch_screen("record")


func _on_how_to_play_pressed():
	pass # Replace with function body.


func _on_log_out_pressed():
	menu_option_select.emit("log out")
	
