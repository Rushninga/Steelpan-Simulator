extends Control
@onready var root = get_tree().current_scene


func _on_back_pressed():
	get_parent().switch_screen("main")
	root.cancel_download_song.rpc_id(1)


func _on_reload_pressed():
	root.request_download_song.rpc_id(1)
	pass
