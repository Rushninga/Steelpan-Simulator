extends Area2D
var mouse_or_touch_position 
@onready var radius = $CollisionShape2D.shape.radius * get_parent().scale.x
var distance_from_mouse 
var note
signal play_note(note_name)

func _ready():
	note = name
	pass

func play():
	mouse_or_touch_position = get_global_mouse_position()
	distance_from_mouse = global_position.distance_to(mouse_or_touch_position)
	if distance_from_mouse <= radius:
		if Input.is_action_just_pressed("play"):
			emit_signal("play_note", note)
			
	pass

func _process(_delta):
	play()
	pass
	
