extends Area2D

var launchedPosition = Vector2(0,0)
var maxRange = 10000
var speed = 1000

# Called when the node enters the scene tree for the first time.
func _ready():
	launchedPosition = position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	if (position - launchedPosition).length() > maxRange:
		self.queue_free()
			
	position += (transform.y) * speed * delta

func _on_body_entered(body):
	if body.get_name() == "player":
		print("restart")
	
	elif body.get_name() == "tile":
		self.queue_free() 
