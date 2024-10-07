extends Control
signal send_data
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_change_pressed():

	if get_parent().mode == "sign in":
		get_parent().mode = "login"
		$Container/Button.text = "Login"
		$Container/Button_change.text = "Haven't Created An Account Yet? Click Here To Sign In"
	else:
		get_parent().mode = "sign in"
		$Container/Button.text = "Sign In"
		$Container/Button_change.text = "Already Have An Account, Click Here To Login"
	pass # Replace with function body.


func _on_button_pressed():
	emit_signal("send_data", $Container/username.text, $Container/password.text)
	pass # Replace with function body.
