extends Control
signal network_opp
# Called when the node enters the scene tree for the first time.
func _ready():
	var size_a = $Container.size
	pivot_offset = size_a/2



func _on_button_pressed():
	emit_signal("network_opp", $Container/Ip_address.text)
	pass 
