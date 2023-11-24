extends Area2D

var speed = 5000
var hooked = false

var launchedPosition = Vector2(0,0)
var direction = 1
var maxRange = 1000

# Called when the node enters the scene tree for the first time.
func _ready():
	launchedPosition = self.position

func _physics_process(delta):
	if not hooked:
		if (position - launchedPosition).length() > maxRange:
			self.queue_free()
			
		position += ((direction * transform.x) + -transform.y) * speed * delta

func _on_body_entered(body):
	if body.get_name() == "tile":
		hooked = true

func set_direction(direction):
	self.direction = direction
