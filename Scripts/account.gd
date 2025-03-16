extends Control
@onready var start_screen = get_parent()
@onready var root = get_tree().get_current_scene()
var username
var password
var password_visible = false
var icon_visible = "uid://pp7bif2nvuma"
var icon_nonvisible = "uid://dwrk7qv8ospyt"

func _ready():
	username = root.username
	password = root.password

func password_visibility(show:bool):
	if show == true:
		return password
	else:
		var length = password.length()
		var value = ""
		for i in range(length):
			value += "#"
		return value
		
	

func _on_visibility_changed():
	if visible == true:
		username = root.username
		password = root.password
		$Label.text = ""
		#hides password upon enetering menu
		password_visible = false
		$ScrollContainer/VBoxContainer/HBoxContainer/show.icon = ResourceLoader.load(icon_visible) 
		$ScrollContainer/VBoxContainer/HBoxContainer/Password.text = "Password: " + password_visibility(password_visible)
		
		$ScrollContainer/VBoxContainer/Username.text = "Username: " + username
		


func _on_button_pressed(): #back_button
	start_screen.switch_screen("main")
	



func _on_show_pressed(): #switches between icons and showing the password 
	if password_visible == false:
		password_visible = true
		$ScrollContainer/VBoxContainer/HBoxContainer/show.icon =  ResourceLoader.load(icon_nonvisible) 
		$ScrollContainer/VBoxContainer/HBoxContainer/Password.text = "Password: " + password_visibility(password_visible)
	else:
		password_visible = false
		$ScrollContainer/VBoxContainer/HBoxContainer/show.icon =  ResourceLoader.load(icon_visible) 
		$ScrollContainer/VBoxContainer/HBoxContainer/Password.text = "Password: " + password_visibility(password_visible)


func _on_c_password_pressed():
	$ScrollContainer/VBoxContainer/CPasswordMenu.visible = true
	root.change_password.rpc_id(1)
	
	
