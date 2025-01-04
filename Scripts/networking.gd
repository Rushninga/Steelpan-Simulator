extends Node
var username
var password
var user_mode = 0 # 0 = not loged in/registering   1 = user is loged in     2 = user is registered    3 = user is registering
var mode

func _ready():
	$StartScreen.data_send.connect(data_send)
	mode = $StartScreen.mode
	

func data_send(username_send, email_send, password_send, mode_send):
	send_user_info.rpc(username_send, email_send, password_send, mode_send)
	

@rpc("any_peer", "reliable", "call_local")
func send_user_info(username_received, email_received , password_received, mode_received):
	pass

@rpc("authority", "unreliable_ordered", "call_remote")
func user_login_confirm(message):
	if message == 1:
		$StartScreen/Control/Container/Label.text = "Username or password is incorrect"
	elif message == 2:
		$StartScreen/Control/Container/Label.text = "You are Loged in"
		user_mode = 1
		mode = "loged in"
	else:
		$StartScreen/Control/Container/Label.text = "Unknown error occurred"
	

@rpc("authority", "reliable", "call_remote")
func valid_email(message):
	if message == 0:
		mode = "verify"
		$StartScreen/verify.visible = true
		$StartScreen/Control.visible = false
		user_mode = 3
	elif message == 1:
		mode = "sign in"
		$StartScreen/Control/Container/Label.text = "Email is already being used"
		$StartScreen/verify.visible = false
		$StartScreen/Control.visible = true
		
		
	
