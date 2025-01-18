extends Control
signal send_data
@onready var parent = get_parent()


# Called when the node enters the scene tree for the first time.
func _ready():
	var size_a = $Container.size
	pivot_offset = size_a/2

func verify_email_format(email:String):
	var ext
	var at_pos = email.find("@", 1)
	if at_pos == -1:
		return false
	else:
		ext = email.right(email.length() - at_pos)
		if ext == "@gmail.com":
			return true
		elif ext == "@outlook.com":
			return true
		elif ext == "@aol.com":
			return true
		elif ext == "@hotmail.com":
			return true
		elif ext == "@yahoo.com":
			return true
		else:
			return false
	

func _process(_delta):
	if parent.mode == "sign in":
		$Container/Button.text = "Sign In"
		$Container/Button_change.text = "Already Have An Account, Click Here To Login"
		$Container/email.visible = true
	elif parent.mode == "login":
		$Container/Button.text = "Login"
		$Container/Button_change.text = "Haven't Created An Account Yet? Click Here To Sign In"
		$Container/email.visible = false
		
		

func _on_button_change_pressed():
	if get_parent().mode == "sign in":
		parent.switch_screen("login")
	elif get_parent().mode == "login":
		parent.switch_screen("sign in")
	


func _on_button_pressed():
	if parent.mode == "sign in" :
		if $Container/username.text == "" or $Container/password.text == "" or $Container/email.text == "":
			$Container/Label.text = "All fields must be filled"
		else:
			if verify_email_format($Container/email.text) == true:
				emit_signal("send_data", $Container/username.text, $Container/email.text, $Container/password.text)
			else:
				$Container/Label.text = "Email format is invalid"
	elif parent.mode == "login":
		if $Container/username.text == "" or $Container/password.text == "":
			$Container/Label.text = "All fields must be filled"
		else:
			emit_signal("send_data", $Container/username.text, $Container/email.text, $Container/password.text)
