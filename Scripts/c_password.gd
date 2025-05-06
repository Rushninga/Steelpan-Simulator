extends Control
var verify = false
@onready var root = get_tree().get_current_scene()

func _ready():
	$PasswordChange.visible = false

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
	



func _on_cancel_pressed():
	$PasswordChange/Password.text = "Enter new password"
	$Verify/Label.text = "Enter verification code sent to your email below:"
	$PasswordChange.visible = false
	$Verify.visible = true
	visible = false


func _on_verify_pressed():
	var code = $Verify/LineEdit.text
	root.cpassword_code.rpc_id(1, code)


func _on_confim_pressed():
	var password = $PasswordChange/LineEdit.text
	if verify_password(password) == true:
		if $PasswordChange/LineEdit.text == $PasswordChange/RPassword.text:
			root.temp_password = password
			root.change_password_to.rpc_id(1, password)
			$PasswordChange/Password.text = "Enter new password"
			$Verify/Label.text = "Enter verification code sent to email below:"
			$PasswordChange.visible = false
			$Verify.visible = true
			visible = false
		else:
			$PasswordChange/Password.text = "Passwords do not match"
			var conn_label = $PasswordChange/Password
			root.get_node("StartScreen").flash_tween(conn_label)
	else:
		$PasswordChange/Password.text = "Password must contain: \n- at least 8 characters \n-An alphabetic character \n-A number\n-A symbol of choice"
		var conn_label = $PasswordChange/Password
		root.get_node("StartScreen").flash_tween(conn_label)
