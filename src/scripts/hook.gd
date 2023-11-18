extends Area2D

var speed = 1700
var hooked = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	if not hooked:
		position += (transform.x + -transform.y) * speed * delta

func _on_body_entered(body):
	if body.get_name() == "tile":
		hooked = true
