extends Node2D
var note_speed = Vector2()
var note:String
var start:float
var end:float
var speed:Vector2
var distance:Vector2
var distance_to_kill:Vector2 
var time_to_kill:float = 3
var kill_speed
var true_scale:Vector2
var time_to_travel 
var delay
var pause = false



func _ready():
	scale = (Vector2(2,2) * true_scale) 
	
	distance = scale - true_scale
	distance_to_kill =  true_scale
	speed = distance/time_to_travel
	kill_speed = distance_to_kill/time_to_kill
	note_speed = Vector2(speed)
	scale -= (speed * delay) #removes scale to compisate delay between supposed spawn time and actrual spawn time
	
	if pause == true:
		note_speed = Vector2(0,0)
		scale = (Vector2(1,1) * true_scale) 
	
	
	
func _process(delta):
	if scale.x >= true_scale.x :
		scale -= note_speed * delta
	else: 
		scale -= kill_speed * delta
		if scale.x <= 0 :
			queue_free()
