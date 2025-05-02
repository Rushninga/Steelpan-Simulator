extends Control
var mode = "connect"
var time = 0.0
var client = ENetMultiplayerPeer.new()
var server_ip
var default_port = 8000
var port = 1080
var pause = 0

var song_play = preload("res://Scenes/song_play.tscn")
var record_song = preload("res://Scenes/song_create.tscn")

signal data_send


#link to node refrences
@onready var user_data_menu = $Control
@onready var connect_menu= $Control2
@onready var connect_menu_label = $Control2/Container/Label
@onready var verify = $verify
@onready var user_data_menu_label = $Control/Container/Label
@onready var main_menu = $MainMenu
@onready var song_list_menu = $Play
@onready var song_list = $Play/VBoxContainer/ScrollContainer/SongList
@onready var score_menu = $Score
@onready var account_menu = $Account


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
	if OS.get_name() == "Android":
		OS.request_permission("android.permission.ACCESS_NETWORK_STATE")
		OS.request_permission("android.permission.INTERNET")
		if OS.request_permissions() == false:
			$Control2/Container/Label.text == "Please grant permissions"
	
	server_ip = ip
	var err = client.create_client(ip, default_port)
	if err != 0:
		$Control2/Container/Label.text = "Your client has failed to connect to the sever \n please verify the ip address entered \n Otherwise sever may be down"
		var conn_label = $Control2/Container/Label
		flash_tween(conn_label)
	multiplayer.multiplayer_peer = client
	

func connected():
	user_data_menu_label.text = "clinet is connected"
	switch_screen("sign in")
	
func client_disconnect():
	connect_menu_label.text = "clinet has disconnected"
	switch_screen("connect")
	var conn_label = $Control2/Container/Label
	flash_tween(conn_label)
	

func connect_fail():
	print("connection failed")
	$Control2/Container/Label.text = "Client has failed to connect"
	var conn_label = $Control2/Container/Label
	flash_tween(conn_label)
	
func switch_screen(screen):
	if screen == "connect":
		mode = "connect"
		connect_menu.visible = true
	else:
		connect_menu.visible = false
	
	if screen == "sign in" or screen == "login": #hides menu based on sign in and login
		user_data_menu.visible = true
	else:
		user_data_menu.visible = false
	
	if screen == "login": #switches mode based on login or sign in
		mode = "login"
		
	if screen == "sign in": #switches mode based on login or sign in
		mode = "sign in"

	if  screen == "verify":
		mode = "verify"
		verify.visible = true
	else:
		verify.visible = false
		
	if screen == "main":
		mode = "main"
		main_menu.visible = true
	else:
		main_menu.visible = false
		
	if screen == "song select":
		mode = "song select"
		song_list_menu.visible = true
	else:
		song_list_menu.visible = false
	
	if screen == "play song":
		mode = "play song"
		get_window().unresizable = true
	else:
		get_window().unresizable = false
		
	if screen == "score":
		mode = "score"
		score_menu.visible = true
	else:
		score_menu.visible = false
		
	if screen == "record":
		mode = "record"
		var record_menu = record_song.instantiate()
		add_child(record_menu)
	
	if screen == "account":
		mode = "account"
		account_menu.visible = true
	else:
		account_menu.visible = false
		
	if screen == "admin":
		mode = "admin"
		$AdminPanel.visible = true
	else:
		$AdminPanel.visible = false
	
	if screen == "how to play":
		mode = "how to play"
		$HowToPlay.visible = true
	else:
		$HowToPlay.visible = false

func cancel_email_verification():
	switch_screen("sign in")



var previous_song_id
func select_song(id, song_name, creator_name, song_data):
	var new_song_play
	new_song_play = song_play.instantiate()
	new_song_play.song_id = id
	new_song_play.song_name = song_name
	new_song_play.creator_name = creator_name
	new_song_play.json = song_data
	new_song_play.song_complete.connect(song_complete)
	new_song_play.practice = $Play.get_node("HBoxContainer/CheckButton").button_pressed
	
	previous_song_id = id #stores current song id in this variable for retring the song
	
	switch_screen("play song")
	add_child(new_song_play)

	
func retry_song(): #searches the song list for the previous id stored in the select song function and emits the select song signal to run the select song function function
	for i in song_list.get_children():
		if i.song_id == previous_song_id:
			i.select_song.emit(i.song_id, i.song_name, i.creator_name, i.song_data)
	

func song_complete(song_id, song_name, creator_name, score, acc):
	score_menu.get_node("Container/SongName").text = "Song Name: " + song_name
	score_menu.get_node("Container/Creator").text = "Creator Name: " + creator_name
	score_menu.get_node("Container/Score").text = "Score: " + str(score)
	score_menu.get_node("Container/Accuracy").text = "Accuracy: " + str(acc) + "%"
	get_parent().request_rankings.rpc_id(1, song_id, score, acc)
	switch_screen("score")

func flash_tween(node:Label):
	for i in range(5):
		node.modulate = Color(255, 0, 0)
		await get_tree().create_timer(0.1).timeout
		node.modulate = Color(255, 255, 255)
		await get_tree().create_timer(0.05).timeout
	
