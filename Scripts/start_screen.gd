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
@onready var verify = $verify
@onready var user_data_menu_label = $Control/Container/Label
@onready var main_menu = $MainMenu
@onready var song_list_menu = $Play
@onready var song_list = $Play/VBoxContainer/ScrollContainer/SongList
@onready var score_menu = $Score


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
		print(err)
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
	print("connection failed")
	$Control2/Container/Label.text = "Client has failed to connect"

func switch_screen(screen):
	if screen == "sign in":
		mode = "sign in"
		user_data_menu.visible = true
		connect_menu.visible = false
		verify.visible = false
		main_menu.visible = false
		song_list_menu.visible = false
		score_menu.visible = false
	elif screen == "login":
		mode = "login"
		user_data_menu.visible = true
		connect_menu.visible = false
		verify.visible = false
		main_menu.visible = false
		song_list_menu.visible = false
		score_menu.visible = false
	elif  screen == "verify":
		mode = "verify"
		user_data_menu.visible = false
		connect_menu.visible = false
		verify.visible = true
		main_menu.visible = false
		song_list_menu.visible = false
		score_menu.visible = false
	elif screen == "connect":
		mode = "connect"
		user_data_menu.visible = false
		connect_menu.visible = true
		verify.visible = false
		main_menu.visible = false
		song_list_menu.visible = false
		score_menu.visible = false
	elif screen == "main":
		mode = "main"
		user_data_menu.visible = false
		connect_menu.visible = false
		verify.visible = false
		main_menu.visible = true
		song_list_menu.visible = false
		score_menu.visible = false
	elif screen == "song select":
		mode = "song select"
		user_data_menu.visible = false
		connect_menu.visible = false
		verify.visible = false
		main_menu.visible = false
		song_list_menu.visible = true
		score_menu.visible = false
		get_window().unresizable = false
	elif screen == "play song":
		mode = "play song"
		user_data_menu.visible = false
		connect_menu.visible = false
		verify.visible = false
		main_menu.visible = false
		song_list_menu.visible = false
		score_menu.visible = false
		get_window().unresizable = true
	elif screen == "score":
		mode = "score"
		user_data_menu.visible = false
		connect_menu.visible = false
		verify.visible = false
		main_menu.visible = false
		song_list_menu.visible = false
		score_menu.visible = true
		get_window().unresizable = false
	elif screen == "record":
		mode = "record"
		user_data_menu.visible = false
		connect_menu.visible = false
		verify.visible = false
		main_menu.visible = false
		song_list_menu.visible = false
		score_menu.visible = false
		var record_menu = record_song.instantiate()
		add_child(record_menu)
		
		

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
