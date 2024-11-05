extends Resource

class_name song
var background_audio = AudioStreamPlayer.new()
var incoming_notes:Array = []

class note:
	var name:String 
	var start:float 
	var end:float 
	var type:String
	func _init(note_name, start_time, end_time):
		name = note_name
		start = start_time
		end = end_time
		if start >=  end:
			type = "single"
		elif start < end :
			type = "roll"
	pass

func add_note(note_name:String, start_time:float, end_time:float = 0.00):
	if end_time == 0.00 :
		end_time = start_time
	incoming_notes.append(note.new(note_name, start_time, end_time)) 

func _init():
	
	add_note("C1",2)
	add_note("D1",3)
	add_note("E1",4)
	add_note("F1",5)
	add_note("G1",6)
	add_note("A1",7)
	add_note("B1",8)
	add_note("C2",9, 12)
	
	pass
