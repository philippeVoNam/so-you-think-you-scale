extends Area2D

var levelNode = null

# Called when the node enters the scene tree for the first time.
func _ready():
	levelNode = get_tree().get_root().get_node("world/level")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_body_entered(body):
	if body.get_name() == "player":
		body.display_msg(99999)
		levelNode.finished()
		self.queue_free()
