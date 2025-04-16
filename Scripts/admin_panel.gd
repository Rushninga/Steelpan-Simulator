extends Control
@onready var root = get_tree().get_current_scene()



func _on_visibility_changed():
	if visible == true:
		for i in $VBoxContainer/ScrollContainer/List.get_children():
			i.queue_free()
		root.admin_info_request.rpc_id(1)
	


func _on_reload_pressed():
	for i in $VBoxContainer/ScrollContainer/List.get_children():
		i.queue_free()
	root.admin_info_cancel.rpc_id(1)
	root.admin_info_request.rpc_id(1)


func _on_back_pressed():
	root.admin_info_cancel.rpc_id(1)
	get_parent().switch_screen("main")

var search_term:String
var length:int
var search_con:String
func _on_search_text_changed(new_text):
	search_term = new_text
	length = search_term.length()
	
	
	
	for i in $VBoxContainer/ScrollContainer/List.get_children():
		search_con = i.get_node("Username").text.left(length)
		print(search_con)
		if length > 0:
			print(i.get_node("Username").text.length())
			if length <= i.get_node("Username").text.length():
				if search_term.to_upper() == search_con.to_upper():
					i.visible = true
				else:
					i.visible = false
			else:
				i.visible = false
		else:
			i.visible = true
