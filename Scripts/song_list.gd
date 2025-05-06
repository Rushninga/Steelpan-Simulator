extends Control
var search_term
var length
var search_con
@onready var root = get_tree().current_scene

func search_song():
	search_term = $VBoxContainer/Top/Search.text
	length = search_term.length()

	for i in $VBoxContainer/ScrollContainer/SongList.get_children():
		search_con = i.song_name.left(length)
		if length > 0:
			if length <= i.song_name.length():
				if search_term.to_upper() == search_con.to_upper():
					i.visible = true
				else:
					i.visible = false
			else:
				i.visible = false
		else:
			i.visible = true


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
	if visible == true:
		for i in $VBoxContainer/ScrollContainer/SongList.get_children():
			i.queue_free()
		root.request_download_song.rpc_id(1)
		
		search_term = $VBoxContainer/Top/Search.text
		length = search_term.length()



func _on_search_text_changed(new_text):
	search_song()
	
