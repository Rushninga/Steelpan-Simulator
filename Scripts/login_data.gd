extends Control
signal send_data
@onready var parent = get_parent()
@onready var root = get_tree().get_current_scene()

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
		elif ext == "@salcc.edu.lc":
			return true
		elif ext == "@apps.salcc.edu.lc":
			return true
		else:
			return false
	

func verify_password(password:String):
	var regex = RegEx.new()
	var valid_password = true
	var regex_string_alpha = "[A-Za-z]"
	var regex_string_number = "[0-9]"
	var regex_string_symbol = "[^a-zA-Z0-9]"
	
	#number of characters
	if password.length() < 8:
		valid_password = false
	
	#alpha
	regex.compile(regex_string_alpha)
	var alpha_result = regex.search(password)
	if alpha_result == null:
		valid_password = false
		
	#number
	regex.compile(regex_string_number)
	var number_result = regex.search(password)
	if number_result == null:
		valid_password = false
		
	#symbol
	regex.compile(regex_string_symbol)
	var symbol_result = regex.search(password)
	if symbol_result == null:
		valid_password = false
		
	return valid_password
	
func verify_username(username:String):
	if username.length() > 5:
		var regex = RegEx.new()
		var regex_string = "[^a-zA-Z0-9]"
		regex.compile(regex_string)
		var result = regex.search(username)
		if result == null:
			return true
		else:
			return false
	else:
		return false
	
func _process(_delta):
	if parent.mode == "sign in":
		$Container/Button.text = "Sign up"
		$Container/Button_change.text = "Already Have An Account, Click Here To Login"
		$Container/enter2.visible = true
		$Container/email.visible = true
		$Container/Forgot_password.visible = false
	elif parent.mode == "login":
		$Container/Button.text = "Login"
		$Container/Button_change.text = "Haven't Created An Account Yet? Click Here To Sign Up"
		$Container/enter2.visible = false
		$Container/email.visible = false
		$Container/Forgot_password.visible = true
		
		

func _on_button_change_pressed():
	$Container/Label.text = ""
	if get_parent().mode == "sign in":
		parent.switch_screen("login")
	elif get_parent().mode == "login":
		parent.switch_screen("sign in")
	

func _on_button_pressed():
	if parent.mode == "sign in" :
		if $Container/username.text == "" or $Container/password.text == "" or $Container/email.text == "":
			$Container/Label.text = "All fields must be filled"
			var conn_label = $Container/Label
			get_parent().flash_tween(conn_label)
		else:
			if verify_username($Container/username.text) == true:
				if verify_email_format($Container/email.text) == true:
					if verify_password($Container/password.text):
						$Container/Label.text = ""
						emit_signal("send_data", $Container/username.text, $Container/email.text, $Container/password.text)
					else:
						$Container/Label.text = "Password must contain: \n- at least 8 characters \n-An alphabetic character \n-A number\n-A symbol of choice "
						var conn_label = $Container/Label
						get_parent().flash_tween(conn_label)
				else:
					$Container/Label.text = "Email format is invalid"
					var conn_label = $Container/Label
					get_parent().flash_tween(conn_label)
			else:
				$Container/Label.text = "-Username must be 6 characters long\n-Username must not contain symbols or spaces"
				var conn_label = $Container/Label
				get_parent().flash_tween(conn_label)
	elif parent.mode == "login":
		if $Container/username.text == "" or $Container/password.text == "":
			$Container/Label.text = "All fields must be filled"
			var conn_label = $Container/Label
			get_parent().flash_tween(conn_label)
		else:
			emit_signal("send_data", $Container/username.text, $Container/email.text, $Container/password.text)

func _on_forgot_password_pressed():
	$Container/Label.text = ""
	var username = $Container/username.text
	root.forgot_password.rpc_id(1, username)
