extends Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready():
	scale = Vector2(0.05,0.05)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if scale.x < 0.3 :
		scale += Vector2(10,10) * delta
	else:
		queue_free()
	pass
