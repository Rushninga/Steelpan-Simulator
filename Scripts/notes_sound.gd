extends Node2D


func _ready():
	for i in get_parent().get_node("Steelpan").get_children():
		if i is Area2D:
			i.play_note.connect(note_played)
	pass
	
func note_played(play):
	for i in get_children():
		if i.name == play :
			i.play()

	pass
