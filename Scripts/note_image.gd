extends Node2D
var note_speed = Vector2()
var note:String
var start:float
var end:float
var speed:Vector2
var distance:Vector2
var distance_to_kill:Vector2 
var type:String
var time_to_kill:float = 1
var kill_speed
var true_scale:Vector2
var time_to_travel 
var delay



func _ready():
	scale = Vector2(20,20)
	
	distance = scale - true_scale
	distance_to_kill =  true_scale
	speed = distance/time_to_travel
	kill_speed = distance_to_kill/time_to_kill
	note_speed = Vector2(speed)
	
	#removes scale to compisate delay between supposed spawn time and actrual spawn time
	scale -= (speed * delay)
	
func _process(delta):
	if scale.x >= true_scale.x :
		scale -= note_speed * delta
	else: 
		scale -= kill_speed * delta
		if scale.x <= 0 :
			queue_free()
	pass
