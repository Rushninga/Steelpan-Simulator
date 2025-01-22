extends Control
signal verify_code_sumbit
signal cancel_email_verifcation
var verify_code




func _on_cancel_pressed():
	cancel_email_verifcation.emit()
	


func _on_verify_pressed():
	verify_code = $VBoxContainer/LineEdit.text
	verify_code_sumbit.emit(verify_code)
	
