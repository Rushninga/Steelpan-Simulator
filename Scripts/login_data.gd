extends Control
signal send_data



# Called when the node enters the scene tree for the first time.
func _ready():
	var size_a = $Container.size
	pivot_offset = size_a/2




func _on_button_change_pressed():

	if get_parent().mode == "sign in":
		get_parent().mode = "login"
		$Container/Button.text = "Login"
		$Container/Button_change.text = "Haven't Created An Account Yet? Click Here To Sign In"
		$Container/email.visible = false
	else:
		get_parent().mode = "sign in"
		$Container/Button.text = "Sign In"
		$Container/Button_change.text = "Already Have An Account, Click Here To Login"
		$Container/email.visible = true
	


func _on_button_pressed():
	emit_signal("send_data", $Container/username.text, $Container/email.text, $Container/password.text)
	
