extends CenterContainer
var mode = "connect"
var time = 0.0
var client = ENetMultiplayerPeer.new()
var server_ip
var default_port = 8000
var port = 1080
var pause = 0
signal data_send


#link to node refrences
@onready var user_data_menu = $Control
@onready var connect_menu= $Control2
@onready var verify = $verify
@onready var user_data_menu_label = $Control/Container/Label



func _ready():
	user_data_menu.send_data.connect(begin_data_send)
	connect_menu.network_opp.connect(begin_network_opp)
	verify.cancel_email_verifcation.connect(cancel_email_verification)
	
	
	multiplayer.connected_to_server.connect(connected)
	multiplayer.connection_failed.connect(connect_fail)
	multiplayer.server_disconnected.connect(client_disconnect)
	
	var screen_size = Vector2i(800,600)
	DisplayServer.window_set_min_size(screen_size, 0)
	
	switch_screen("connect")
	
	
	
func begin_data_send(username, email, password):
	if multiplayer.multiplayer_peer.get_connection_status() == 2:
		emit_signal("data_send", username, email, password, mode)
		
	
func begin_network_opp(ip):
	server_ip = ip
	client.create_client(ip, default_port)
	multiplayer.multiplayer_peer = client
	

func connected():
	user_data_menu_label.text = "clinet is connected"
	mode = "sign in"
	switch_screen("sign in")
	
func client_disconnect():
	user_data_menu_label.text = "clinet is disconnected"
	mode = "connect"
	user_data_menu.visible = false
	connect_menu.visible = true
	verify.visible = false
	switch_screen("connect")

func connect_fail():
	user_data_menu_label.text = "clinet has failed to connect"

func switch_screen(screen):
	if screen == "sign in":
		mode = "sign in"
		user_data_menu.visible = true
		connect_menu.visible = false
		verify.visible = false
	elif screen == "login":
		mode = "login"
		user_data_menu.visible = true
		connect_menu.visible = false
		verify.visible = false
	elif  screen == "verify":
		mode = "verify"
		user_data_menu.visible = false
		connect_menu.visible = false
		verify.visible = true
	elif screen == "connect":
		mode = "connect"
		user_data_menu.visible = false
		connect_menu.visible = true
		verify.visible = false
	elif screen == "main":
		mode = "main"
	elif screen == "play":
		mode = "play"
	elif screen == "record":
		mode = "record"
		

func cancel_email_verification():
	switch_screen("sign in")
	mode = "sign in"
	
