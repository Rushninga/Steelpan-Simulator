extends Node
var note_played_time_difference 
signal quality(difference)

func _ready():
	for i in get_children():
		if i is Area2D:
			i.play_note.connect(note_played)
	pass
	
func note_played(play):
	for i in get_parent().get_node("Incoming_notes").get_children():
			if i.note == play:
				if i.type == "single":
					note_played_time_difference = get_parent().song_time - i.start
					i.queue_free()
					get_parent().hit_notes.append(play)
					emit_signal("quality",note_played_time_difference)
					break
				elif i.scale.x <= i.true_scale.x:
					print("rolling")
					break
	pass
