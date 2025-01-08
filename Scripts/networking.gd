extends Node
var server_ip
var username
var password


func _ready():
	$StartScreen.data_send.connect(data_send)
	$StartScreen/verify.verify_code_sumbit.connect(verify_code_sumbit)
	server_ip = $StartScreen.server_ip
	
	

func data_send(username_send, email_send, password_send, mode_send):
	send_user_info.rpc(username_send, email_send, password_send, mode_send)
	
func verify_code_sumbit(code):
	sumbit_email_code.rpc(code)
	pass
	

@rpc("any_peer", "reliable", "call_local")
func send_user_info(username_received, email_received , password_received, mode_received):
	pass

@rpc("authority", "unreliable_ordered", "call_remote")
func user_login_confirm(message):
	if message == 1:
		$StartScreen/Control/Container/Label.text = "Username or password is incorrect"
	elif message == 2:
		$StartScreen/Control/Container/Label.text = "You are Loged in"
	else:
		$StartScreen/Control/Container/Label.text = "Unknown error occurred"
	

@rpc("authority", "reliable", "call_remote")
func valid_email(message):
	if message == 0:
		$StartScreen.switch_screen("verify")
	elif message == 1:
		$StartScreen/Control/Container/Label.text = "Email is already being used"
		$StartScreen.switch_screen("sign in")
		
		
@rpc("any_peer", "reliable")
func sumbit_email_code(code):
	pass

@rpc("authority", "reliable")
func valid_email_code(message):
	if message == 0:
		$StartScreen.switch_screen("login")
		$StartScreen/Control/Container/Label.text = "You can now login"
	else:
		$StartScreen/verify/VBoxContainer/Label.text = "The code you entered is invalid"
	
