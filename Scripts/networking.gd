extends Node
var server_ip
var client
var username
var password
var crypto = Crypto.new()
var net_key = CryptoKey.new()
var verify_session_interval = 60
var login:bool = false
var song_container = preload("res://GUI/song_container.tscn")

func _ready():
	$StartScreen.data_send.connect(data_send)
	$StartScreen/verify.verify_code_sumbit.connect(verify_code_sumbit)
	$StartScreen/MainMenu.menu_option_select.connect(menu_option_select)
	

	client = $StartScreen.client
	server_ip = $StartScreen.server_ip
	

func _process(delta):
	if login == true:
		verify_session_interval -= delta
		if verify_session_interval < 0:
			verify_session.rpc_id(1)
			verify_session_interval = 60
			

func add_song(id, song_name):
	var new_song = song_container.instantiate()
	new_song.id = id
	new_song.song_name = song_name
	new_song.select_song.connect($StartScreen.select_song)
	$StartScreen/Play/VBoxContainer/ScrollContainer/SongList.add_child(new_song)
	

#code ran by signals from StartScreen and its children
func data_send(username_send, email_send, password_send, mode_send):
	send_user_info.rpc_id(1,username_send, email_send, password_send, mode_send)
	username = username_send
	
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
		login = false


#rpcs
@rpc("any_peer", "reliable", "call_local")
func send_user_info(username_received, email_received , password_received, mode_received):
	pass

@rpc("authority", "unreliable_ordered", "call_remote")
func user_login_confirm(message):
	if message == 1:
		$StartScreen/Control/Container/Label.text = "Username or password is incorrect"
	elif message == 2:
		$StartScreen.switch_screen("main")
		$StartScreen/MainMenu/HBoxContainer/RightSide/Header.text = "Welcome \n " + username
		login = true
	else:
		$StartScreen/Control/Container/Label.text = "Unknown error occurred"
	

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
func verify_session_response(message): #0 = session is valid, 1 = session is valid
	print(message)
	if message == 0:
		$StartScreen.switch_screen("login")
		$StartScreen/Control/Container/Label.text = "Your session has timed out"
		login = false
	else:
		print("Your session is valid")
	
@rpc("any_peer", "reliable")
func log_out():
	pass
	
@rpc("any_peer", "reliable")
func request_download_song():
	pass
	
@rpc("authority", "reliable")
func download_song(song_id, song_name, song_data):
	print(song_id)
	print(song_name)
	var json = JSON.parse_string(song_data)
	for i in json:
		print(i)
