extends Area2D

var levelNode = null
var enable = true

# Called when the node enters the scene tree for the first time.
func _ready():
	levelNode = get_tree().get_root().get_node("world/level")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_body_entered(body):
	if enable:
		if body.get_name() == "player":
			levelNode.start()
			enable = false
		
func renable():
	enable = true
