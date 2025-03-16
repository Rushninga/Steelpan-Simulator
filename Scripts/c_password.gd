extends Control
var verify = false
@onready var root = get_tree().get_current_scene()

func _ready():
	$PasswordChange.visible = false




func _on_cancel_pressed():
	$PasswordChange/Password.text = "Enter new password"
	$Verify/Label.text = "Enter verification code sent to email below:"
	$PasswordChange.visible = false
	$Verify.visible = true
	visible = false


func _on_verify_pressed():
	var code = $Verify/LineEdit.text
	root.cpassword_code.rpc_id(1, code)


func _on_confim_pressed():
	var password = $PasswordChange/LineEdit.text
	root.temp_password = password
	root.change_password_to.rpc_id(1, password)
