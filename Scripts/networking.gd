extends Node
var server_ip
var client
var username
var password
var user_email
var temp_password
var crypto = Crypto.new()
var net_key = CryptoKey.new()
var verify_session_interval = 20
var login:bool = false
var song_container = preload("res://GUI/song_container.tscn")
var entry = preload("res://GUI/adminpanel_score.tscn")

func _ready():
	$StartScreen.data_send.connect(data_send)
	$StartScreen/verify.verify_code_sumbit.connect(verify_code_sumbit)
	$StartScreen/MainMenu.menu_option_select.connect(menu_option_select)
	

	client = $StartScreen.client
	server_ip = $StartScreen.server_ip
	

func _process(delta):
	if login == true:
		if Input.is_key_pressed(KEY_F1):
			$StartScreen.switch_screen("admin")
	
	if login == true:
		verify_session_interval -= delta
		if verify_session_interval < 0:
			verify_session.rpc_id(1)
			verify_session_interval = 10
			


#code ran by signals from StartScreen and its children
func data_send(username_send, email_send, password_send, mode_send):
	send_user_info.rpc_id(1,username_send, email_send, password_send, mode_send)
	username = username_send
	password = password_send
	
func verify_code_sumbit(code):
	sumbit_email_code.rpc_id(1, code)
	

	
func menu_option_select(option):
	# respective data transimitted when menu_option_select when one of the buttons are pressed
	# play = _on_play_pressed():
	# create = _on_create_pressed():
	# how = _on_how_to_play_pressed():
	# log out = _on_log_out_pressed():
	if option == "log out":
		log_out.rpc_id(1)
		$StartScreen.switch_screen("login")
		$StartScreen/Control/Container/Label.text = ""
		login = false


#rpcs
@rpc("any_peer", "reliable", "call_local")
func send_user_info(username_received, email_received , password_received, mode_received):
	pass

@rpc("authority", "unreliable_ordered", "call_remote")
func user_login_confirm(message, email):
	if message == 1:
		$StartScreen/Control/Container/Label.text = "Username or password is incorrect"
		var conn_label = $StartScreen/Control/Container/Label
		$StartScreen.flash_tween(conn_label)
	elif message == 2:
		$StartScreen.switch_screen("main")
		$StartScreen/MainMenu/HBoxContainer/RightSide/Header.text = "Welcome \n " + username
		user_email = email
		login = true
		$StartScreen/Control/Container/username.text = ""
		$StartScreen/Control/Container/password.text = ""
		$StartScreen/Control/Container/email.text = ""
		$StartScreen/Control/Container/RPassword.text = ""
		
	else:
		$StartScreen/Control/Container/Label.text = "Unknown error occurred"
		var conn_label = $StartScreen/Control/Container/Label
		$StartScreen.flash_tween(conn_label)
	

@rpc("authority", "reliable", "call_remote")
func valid_email(message):
	if message == 0:
		$StartScreen.switch_screen("verify")
	elif message == 1:
		$StartScreen/Control/Container/Label.text = "Username or Email is already being used"
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
	
@rpc("any_peer", "reliable")
func verify_session():
	pass
	
@rpc("authority", "reliable")
func verify_session_response(message): #0 = session is invalid, 1 = session is valid
	if message == 0:
		$StartScreen.switch_screen("login")
		$StartScreen/Control/Container/Label.text = "Your session has timed out "
		login = false
	
@rpc("any_peer", "reliable")
func log_out():
	pass
	
@rpc("any_peer", "reliable")
func request_download_song():
	pass
	
@rpc("authority", "reliable")
func download_song(song_id, song_name, creator_name, song_data):
	var new_song = song_container.instantiate()
	new_song.song_id = song_id
	new_song.song_name = song_name
	new_song.song_data = song_data
	new_song.creator_name = str(creator_name)
	new_song.select_song.connect($StartScreen.select_song)
	$StartScreen/Play/VBoxContainer/ScrollContainer/SongList.add_child(new_song)
	$StartScreen/Play.search_song()
	
@rpc("any_peer", "reliable")
func cancel_download_song():
	pass

@rpc("any_peer", "reliable")
func request_rankings(song_id, score, accuracy):
	pass
	
@rpc("authority", "reliable")
func rankings(score, accuracy, rank):
	if score == null or accuracy == null or rank == null:
		$StartScreen/Score/Container/HighScore.text = "An error has occured"
		$StartScreen/Score/Container/HighestAccuracy.text = "An error has occured"
		$StartScreen/Score/Container/Rank.text = "An error has occured"
	else:
		$StartScreen/Score/Container/HighScore.text = "High Score: " + str(score)
		$StartScreen/Score/Container/HighestAccuracy.text = "Highest Accuracy: " + str(accuracy) + "%"
		$StartScreen/Score/Container/Rank.text = "Server Rank: " + str(rank)

@rpc("any_peer", "reliable")
func upload_song(song_name, song_json):
	pass

signal invalid_song_name
@rpc("authority", "reliable")
func valid_song_name(message):
	invalid_song_name.emit(message)
	print(message)
	
@rpc("any_peer", "reliable")
func change_password():
	pass

@rpc("any_peer", "reliable")
func cpassword_code(code):
	pass

@rpc("authority", "reliable")
func cpassword_code_response(message):
	if message == 0:
		$StartScreen/Account/ScrollContainer/VBoxContainer/CPasswordMenu/Verify.visible = false
		$StartScreen/Account/ScrollContainer/VBoxContainer/CPasswordMenu/PasswordChange.visible = true
	else:
		$StartScreen/Account/ScrollContainer/VBoxContainer/CPasswordMenu/Verify/Label.text = "The code entered was incorrect, Please try again"
		var conn_label = $StartScreen/Account/ScrollContainer/VBoxContainer/CPasswordMenu/Verify/Label
		$StartScreen.flash_tween(conn_label)
		
@rpc("any_peer", "reliable")
func change_password_to(password):
	pass

@rpc("authority", "reliable")
func change_password_to_response(message):
	if message == 1:
		$StartScreen/Account/ScrollContainer/VBoxContainer/CPasswordMenu/Verify/Label.text = "An error has occured, Cancel the current operation and try again"
	else:
		password = temp_password
		$StartScreen/Account/Label.text = "Password has been changed successfully"
		$StartScreen/Account.password = password #updates password value
		$StartScreen/Account.password_visible = false #changes password visibility state to invisible
		var new_password = $StartScreen/Account.password_visibility(false) 
		$StartScreen/Account/ScrollContainer/VBoxContainer/HBoxContainer/Password.text = "Password: " + new_password #makes password invisible
		$StartScreen/Account/ScrollContainer/VBoxContainer/CPasswordMenu.visible = false #hides change password menu

@rpc("any_peer", "reliable")
func forgot_password(username):
	pass
	
@rpc("authority", "reliable")
func forgot_password_response(message):#0 = account exsists, 1 = account doesn't exsist
	if message == 1:
		$StartScreen/Control/Container/Label.text = "The account entered doesn't exsist \n Please enter the correct username in the username field"
		var conn_label = $StartScreen/Control/Container/Label
		$StartScreen.flash_tween(conn_label)
	else:
		$StartScreen/Control/Container/Label.text = "Your password has been sent to your email"

@rpc("any_peer", "reliable")
func admin_info_request():
	
	pass
	
@rpc("authority", "reliable")
func admin_info_response(type:String, username:String, email:String, song_name:String, creator:String, accuracy):
	print(type)
	if type == "not admin":
		$StartScreen.switch_screen("main")
	elif type == "score":
		var new_entry = entry.instantiate()
		new_entry.get_node("Username").text = str(username)
		new_entry.get_node("Song").text = str(song_name)
		new_entry.get_node("Accuracy").text = str(accuracy)
		$StartScreen/AdminPanel/VBoxContainer/ScrollContainer/List.add_child(new_entry)
	else:
		$StartScreen.switch_screen("main")
	
	
@rpc("any_peer", "reliable")
func admin_info_cancel():
	pass
