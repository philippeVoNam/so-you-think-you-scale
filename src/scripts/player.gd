extends CharacterBody2D

enum STATES {UNHOOKED, HOOKED}
var state = STATES.UNHOOKED

var hookScene = preload("res://src/scenes/hook.tscn")
var hook = null

const SPEED = 1000.0
const JUMP_VELOCITY = -1800.0

const DAMPING = 1

var angularAcceleration = 0
var angularVelocity = 0
var angle = 0
var r = 0
var momentum = Vector2(0,0)
var lastHookedVelocity = Vector2(0,0)

var firstFlag = true

var jumpCharges = 0
var maxJumpCharges = 1

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):		
	match state:
		STATES.UNHOOKED:
			if is_on_floor():
				jumpCharges = maxJumpCharges # # refresh jump on hook
				
			# Add the gravity.
			if not is_on_floor():
				velocity.y += gravity * delta * 4

			# Handle Jump.
			if Input.is_action_just_pressed("ui_accept"):
				if jumpCharges > 0:
					jumpCharges -= 1
					velocity.y = JUMP_VELOCITY

			# Get the input direction and handle the movement/deceleration.
			# As good practice, you should replace UI actions with custom gameplay actions.
			var direction = Input.get_axis("ui_left", "ui_right")
			if direction:
				velocity.x = direction * SPEED
			else:
				if is_on_floor():
					velocity.x = move_toward(velocity.x, 0, SPEED)
			
			move_and_slide()
			
		STATES.HOOKED:
			jumpCharges = maxJumpCharges # refresh jump on hook
			self.swing(delta)
			queue_redraw()
			move_and_slide()
	
func _input(event):
	pass

func swing(delta):
	var rLength = int(round(self.r.length()))
	
	self.angularAcceleration = (-1 * gravity/3 * delta * sin(self.angle)) / rLength 
	self.angularVelocity += self.angularAcceleration
	self.angularVelocity *= DAMPING
	self.angle += self.angularVelocity
	
	self.position = self.hook.position + Vector2(rLength * sin(self.angle), rLength * cos(self.angle))
 
func _process(delta):
	if Input.is_action_pressed("hook"):
		if not self.hook:
			self.hook = hookScene.instantiate()
			self.hook.position = self.position
			var direction = Input.get_axis("ui_left", "ui_right")
			self.hook.set_direction(direction)
			var levelNode = get_tree().get_root().get_node("level")
			levelNode.add_child(self.hook)
			
		else:
			if self.hook.hooked:
				self.state = STATES.HOOKED
				self.init_hook()
				
	elif Input.is_action_just_released("hook"):
		if self.hook:
			if is_instance_valid(self.hook):
				self.hook.queue_free()
			self.hook = null
			queue_redraw()
		firstFlag = true
		
		if self.state == STATES.HOOKED:
			# add impulse
			var direction = Input.get_axis("ui_left", "ui_right")
			velocity = Vector2(direction * 500,-1550) # we dont do += because we want it to always be this impulse as the first velocity for it, the gravity will take care of the rest after
			
			self.state = STATES.UNHOOKED
		
func init_hook():
	if firstFlag:
		# set initial angle
		var direction = Input.get_axis("ui_left", "ui_right")
		if direction == 1:
			self.r = self.hook.position - self.position
			self.angle = atan2(r.y, r.x)
			self.angularVelocity = 0.1

		else:
			self.r = self.position - self.hook.position
			self.angle = atan2(r.y, r.x)
			self.angularVelocity = -0.1

		firstFlag = false
		
func _draw():
	if self.hook:
		var hookLine = self.hook.position - self.position
		draw_line(Vector2.ZERO, hookLine * 2, Color.AQUAMARINE, 8)
