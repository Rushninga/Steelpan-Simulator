extends Node2D
var note_speed = Vector2()
var note:String
var start:float
var end:float
var speed:Vector2
var distance:Vector2
var roll_time:float
var roll_speed:float
var true_scale:Vector2

@onready var time_to_travel = get_parent().get_parent().note_travel_time
@onready var delay

func _ready():
	scale = Vector2(2,2) - (speed * delay)
	distance = scale - true_scale
	speed = distance/time_to_travel
	note_speed = Vector2(speed)
	roll_time =  end - start
	roll_speed = $TextureProgressBar.value / roll_time
	var tween = create_tween()
	tween.tween_property($".", "modulate", Color("ffffff"), time_to_travel/4).set_trans(Tween.TRANS_LINEAR)
	
	
func _process(delta):
	if scale.x >= true_scale.x :
		scale -= note_speed * delta
	elif $TextureProgressBar.value > 0:
		$TextureProgressBar.value -= roll_speed * delta
	else:
		queue_free()
	
