extends Node2D
var mode = "connect"
var time = 0.0
var client = ENetMultiplayerPeer.new()
var default_port = 8000
var port = 1080
var pause = 0
signal data_send

func _ready():
	$Control.send_data.connect(begin_data_send)
	$Control2.network_opp.connect(begin_network_opp)
	multiplayer.connected_to_server.connect(connected)
	multiplayer.connection_failed.connect(connect_fail)
	multiplayer.server_disconnected.connect(client_disconnect)

	#centers control node at the center of the screen
	$Control.global_position = $Camera2D.global_position
	$Control2.global_position = $Camera2D.global_position
	
func _process(delta):
	#sets control node visibility depending if the client is connected to the server
	if mode == "connect":
		$Control.visible = false
		$Control2.visible = true
	else:
		$Control.visible = true
		$Control2.visible = false
	
	
func begin_data_send(username, password):
	if multiplayer.multiplayer_peer.get_connection_status() == 2:
		emit_signal("data_send", username, password, mode)
		pass
	pass
	
func begin_network_opp(ip):
	client.create_client(ip, default_port)
	multiplayer.multiplayer_peer = client
	

func connected():
	$Control/Container/Label.text = "clinet is connected"
	$Control/Container/Button.disabled = false
	$Control/Container/Button_change.disabled = false
	$Control2/Container/Button.disabled = true
	mode = "sign in"
	
func client_disconnect():
	$Control/Container/Label.text = "clinet is disconnected"
	$Control/Container/Button.disabled = true
	$Control/Container/Button_change.disabled = true
	$Control2/Container/Button.disabled = false
	mode = "connect"

func connect_fail():
	$Control/Container/Label.text = "clinet has failed to connect"
