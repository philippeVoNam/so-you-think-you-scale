extends Area2D

var speed = 5000
var hooked = false

var direction = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	if not hooked:
		position += ((direction * transform.x) + -transform.y) * speed * delta

func _on_body_entered(body):
	if body.get_name() == "tile":
		hooked = true

func set_direction(direction):
	self.direction = direction
 
