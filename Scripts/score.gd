extends Control




func _on_retry_pressed():
	get_parent().retry_song()

func _on_back_pressed():
	get_parent().switch_screen("song select")
