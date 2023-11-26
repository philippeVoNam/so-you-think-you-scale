extends Node2D

var snowScene = preload("res://src/scenes/snow.tscn")
var snow = null
var _timer = null

var timeReachGoal = 0
var timeStart = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	timeStart = Time.get_unix_time_from_system()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
#	await get_tree().create_timer(3.0).timeout # waits for 1 second
#	generate_snow()
	pass
	
func restart():
	pass
	
func finished():
	timeReachGoal = Time.get_unix_time_from_system() - timeStart
	print("finished run in : " + str(timeReachGoal) + " seconds")
	
func generate_snow():
	self.snow = snowScene.instantiate()
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var xPos = rng.randi_range(0, 4000)
	var yPos = -8000
	self.snow.position = Vector2(xPos, yPos)
	self.add_child(snow)
