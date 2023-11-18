extends CharacterBody2D

enum STATES {UNHOOKED, HOOKED}
var state = STATES.UNHOOKED

var hookScene = preload("res://src/scenes/hook.tscn")
var hook = null

const SPEED = 300.0
const JUMP_VELOCITY = -500.0

const DAMPING = 0.995

var angularAcceleration = 0
var angularVelocity = 0
var angle = 0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	match state:
		STATES.UNHOOKED:
			# Add the gravity.
			if not is_on_floor():
				velocity.y += gravity * delta

			# Handle Jump.
			if Input.is_action_just_pressed("ui_accept") and is_on_floor():
				velocity.y = JUMP_VELOCITY

			# Get the input direction and handle the movement/deceleration.
			# As good practice, you should replace UI actions with custom gameplay actions.
			var direction = Input.get_axis("ui_left", "ui_right")
			if direction:
				velocity.x = direction * SPEED
			else:
				velocity.x = move_toward(velocity.x, 0, SPEED)

			move_and_slide()
			
		STATES.HOOKED:
			self.swing(delta)
	
func _input(event):
	if event is InputEventKey:
		if Input.is_key_pressed(KEY_C):
			if self.hook:
				self.hook.queue_free()
				
			self.hook = hookScene.instantiate()
			self.hook.position = self.position
			var levelNode = get_tree().get_root().get_node("level")
			levelNode.add_child(self.hook)

func swing(delta):
	var r = self.hook.position - self.position
	self.angle = atan2(r.y, r.x)
	
	self.angularAcceleration = (-1 * gravity * delta * sin(self.angle)) / r.length()
	self.angularVelocity += self.angularAcceleration
	self.angularVelocity *= DAMPING
	self.angle += self.angularVelocity
	
	self.position = self.hook.position + Vector2(r.length() * sin(self.angle), r.length() * cos(self.angle))

func _process(delta):
	if self.hook:
		if self.hook.hooked:
			self.state = STATES.HOOKED
			
func _draw():
	if self.hook:
		draw_line(self.hook.position, self.position, Color.WHITE, 3.0)
