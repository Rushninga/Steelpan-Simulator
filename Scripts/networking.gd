extends Node
var username
var password

func _ready():
	$StartScreen.data_send.connect(send_data)
	pass

func send_data(username_send, password_send, mode_send):
	send_user_info.rpc(username_send, password_send, mode_send)
	

@rpc("any_peer", "reliable", "call_local")
func send_user_info(username_recieved, password_received, mode_received):
	pass

@rpc("authority", "unreliable_ordered", "call_remote")
func user_login_confirm():
	$StartScreen/Control/Container/Label.text = "You are Loged in"
	pass
