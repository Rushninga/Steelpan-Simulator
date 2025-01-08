extends Control
signal verify_code_sumbit
signal cancel_email_verifcation
var verify_code

# Called when the node enters the scene tree for the first time.
func _ready():
	pass 


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_cancel_pressed():
	cancel_email_verifcation.emit()
	


func _on_verify_pressed():
	verify_code = $VBoxContainer/LineEdit.text
	verify_code_sumbit.emit(verify_code)
	
