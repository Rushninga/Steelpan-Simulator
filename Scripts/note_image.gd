extends Node2D
var note_speed = Vector2()
var note
var start
var end
var speed = 0
var distance
var distance_to_kill 
var type
@onready var time_to_travel = get_parent().get_parent().note_travel_time
var time_to_kill = 1
var kill_speed = 0
@onready var steelpan_obj_scale = get_parent().get_parent().get_node("Steelpan").scale
var true_scale


func _ready():
	scale = Vector2(20,20)
	
	for i in get_parent().get_parent().get_node("Steelpan").get_children():
		if i.name == note:
			true_scale = i.scale * steelpan_obj_scale
	
	distance = scale - true_scale
	distance_to_kill =  true_scale
	speed = distance/time_to_travel
	kill_speed = distance_to_kill/time_to_kill
	note_speed = Vector2(speed)
	
	pass 

func _process(delta):
	if scale.x >= steelpan_obj_scale.x :
		scale -= note_speed * delta
	else: 
		scale -= kill_speed * delta
		if scale.x <= 0 :
			queue_free()
	pass
