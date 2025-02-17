extends Control
@onready var root = get_tree().current_scene


func _on_back_pressed():
	get_parent().switch_screen("main")
	root.cancel_download_song.rpc_id(1)
	for i in $VBoxContainer/ScrollContainer/SongList.get_children():
		i.queue_free()


func _on_reload_pressed():
	for i in $VBoxContainer/ScrollContainer/SongList.get_children():
		i.queue_free()
	root.cancel_download_song.rpc_id(1)
	root.request_download_song.rpc_id(1)
	


func _on_visibility_changed():
	for i in $VBoxContainer/ScrollContainer/SongList.get_children():
		i.queue_free()
	if visible == true:
		root.request_download_song.rpc_id(1)
