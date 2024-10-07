extends Node2D
var counter:int = 0
var song_time:float = 0
var incoming_notes:Array = []
var song_res:Resource = preload("res://Save Data/songs/test_song/test song.tres")
var note_image = preload("res://Objects/note_image.tscn")
var roll_note_image = preload("res://Objects/rolling note.tscn")
var song_end = false
@export var note_travel_time:float
var hit_notes:Array = []
var incoming_note

func _ready():
	$Steelpan.quality.connect(note_is_played)
	if note_travel_time == null:
		note_travel_time = 3
	incoming_notes = song_res.incoming_notes
	for i in incoming_notes :
		i.start += note_travel_time
	pass



func _process(delta):
	hit_notes = []
	if counter < incoming_notes.size():
		if ( incoming_notes[counter].start - note_travel_time ) <= song_time :
			for i in $Steelpan.get_children():
				if "note" in i:
					if i.note == incoming_notes[counter].name:
						if incoming_notes[counter].start == incoming_notes[counter].end :
							incoming_note = note_image.instantiate()
						
						$Incoming_notes.add_child(incoming_note)
						incoming_note.note = i.note
						incoming_note.start = incoming_notes[counter].start
						incoming_note.end = incoming_notes[counter].end
						incoming_note.global_position = i.global_position
			counter += 1
	song_time += delta
	pass
	
func note_is_played(diff):
	if diff > -0.05 and diff < 0.05:
		print("perfect")
	elif diff > -0.1 and diff < 0.1:
		print("good")
	elif diff > -0.2 and diff < 0.2:
		print("Sloppy")
	elif diff > -0.5 and diff < 0.5:
		print("Sh**")
	else:
		print("U suck lmfao")
	pass
