extends Node2D
var mode = "sign in"
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
	#send_user_info.rpc(str(multiplayer.get_unique_id()))
	
func client_disconnect():
	$Control/Container/Label.text = "clinet is disconnected"
	$Control/Container/Button.disabled = true
	$Control/Container/Button_change.disabled = true
	$Control2/Container/Button.disabled = false
	pass

func connect_fail():
	$Control/Container/Label.text = "clinet has failed to connect"
