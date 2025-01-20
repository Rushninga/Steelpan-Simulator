extends HBoxContainer
signal select_song
var id:int = 0
var song_name:String = "Test Song"
var song_data:Array = []


func _ready():
	name = song_name
	$SongName.text = song_name

func _on_play_pressed():
	select_song.emit(id, song_name, song_data)
	
