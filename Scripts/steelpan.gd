extends Node2D
var note_played_time_difference 
signal quality(difference)
signal rolling

func _ready(): #connects the signal that is emitted when a note is played for all notes 
	for i in get_children():
		if i is Area2D:
			i.play_note.connect(note_played)
			i.visible = false
	
	
func note_played(play):
	for i in get_parent().get_node("Incoming_notes").get_children():
			if i.note == play:
				if i.start == i.end:
					note_played_time_difference = get_parent().song_time - i.start
					i.queue_free()
					get_parent().hit_notes.append(play)
					emit_signal("quality",note_played_time_difference) #emits a signal that send the difference between the time the note is played and its actrual time in the song
					break
				elif i.scale.x <= i.true_scale.x:
					print("rolling")
					break
				break
