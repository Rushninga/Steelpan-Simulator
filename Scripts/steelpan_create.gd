extends "res://Scripts/steelpan.gd"
var buffer_note = {
	"note": "",
	"start": 0,
	"end": 0
}
var roll_note_cut_off = 1

func note_played(note):
	if get_parent().first_note_played == false:
		get_parent().first_note_played = true
	if get_parent().create_state == 1: #code run when recording song. Stores the note that is played and what time it is played. When the mouse is released, the note is stored in stored_notes which makes up the recorded song
		buffer_note["note"] = note
		buffer_note["start"] = get_parent().song_time
	if get_parent().create_state == 2: # Code run when previewing song
		for i in get_parent().get_node("Incoming_notes").get_children():
			if i.note == note:
				if i.start == i.end:
					note_played_time_difference = get_parent().song_time - i.start
					i.queue_free()
					get_parent().hit_notes.append(note)
					emit_signal("quality",note_played_time_difference) #emits a signal that send the difference between the time the note is played and its actrual time in the song
					break
				elif i.scale.x <= i.true_scale.x:
					print("rolling")
					break

func _process(delta):
	if get_parent().create_state == 1:
		if Input.is_action_pressed("play"):
			roll_note_cut_off -= delta
		
		if Input.is_action_just_released("play") and buffer_note["note"] != "":
			if roll_note_cut_off < 0:
				buffer_note["end"] = get_parent().song_time
				get_parent().stored_notes.append(buffer_note)
				reset_buffer_note()
			else:
				buffer_note["end"] = buffer_note["start"]
				get_parent().stored_notes.append(buffer_note)
				reset_buffer_note()
			roll_note_cut_off = 1
	

func reset_buffer_note():
	buffer_note =  {
					"note": "",
					"start": 0,
					"end": 0
				}
