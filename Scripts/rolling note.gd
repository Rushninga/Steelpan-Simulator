extends Node2D
var note_speed = Vector2()
var note
var start
var end
var speed = 0
var distance
var roll_time
var roll_speed
var type
@onready var time_to_travel = get_parent().get_parent().note_travel_time
@onready var steelpan_obj_scale = get_parent().get_parent().get_node("Steelpan").scale
var true_scale

func _ready():
	scale = Vector2(20,20)
	
	for i in get_parent().get_parent().get_node("Steelpan").get_children():
		if i.name == note:
			true_scale = i.scale * steelpan_obj_scale
	
	distance = scale - true_scale
	speed = distance/time_to_travel
	note_speed = Vector2(speed)
	roll_time =  end - start
	roll_speed = $TextureProgressBar.value / roll_time
	pass 
	
	
func _process(delta):
	if scale.x >= true_scale.x :
		scale -= note_speed * delta
	elif $TextureProgressBar.value > 0:
		$TextureProgressBar.value -= roll_speed * delta
	else:
		queue_free()
	pass
