extends Node2D

var snowScene = preload("res://src/scenes/snow.tscn")

var playerNode = null
var startNode = null
var timerLabelNode = null
var msgLabelNode = null
var centerContainerNode = null
var snow = null
var _timer = null

var timeReachGoal = 0
var timeStart = 0
var elaspedTime = 0

var mutex = null
var voice_id = 0
var osName = ""

var started = false

# Called when the node enters the scene tree for the first time.
func _ready():
	osName = OS.get_name()
	mutex = Mutex.new()
	playerNode = get_tree().get_root().get_node("world/level/player")
	startNode = get_tree().get_root().get_node("world/level/start")
	timerLabelNode = get_tree().get_root().get_node("world/canvas/control/container/timer_label")
	msgLabelNode = get_tree().get_root().get_node("world/canvas/control/center_container/msg_label")
	centerContainerNode = get_tree().get_root().get_node("world/canvas/control/center_container")
	_timer = get_tree().get_root().get_node("world/Timer")
	_timer.start()
	
	# One-time steps.
	# Pick a voice. Here, we arbitrarily pick the first English voice.
	var voices = DisplayServer.tts_get_voices_for_language("en")
	voice_id = voices[1]
	
#	await get_tree().create_timer(1).timeout
	await self.display_msg("Welcome test subject # 15042 to the Science Culture Activities Learning Environement. S.C.A.L.E for short", 0.05, 2, 0.01)
	await self.display_msg("Do not worry, you are perfectly safe. Comply with our instructions and everything will be okay", 0.05, 2, 0.01)
	await self.display_msg("We care about you deeply, [subject name here]", 0.01, 2, 0.01)
	await self.display_msg("We have equipped you with our latest hook technology for you to test out", 0.01, 2, 0.01)
	await self.display_msg("Use the arrow keys and space bar to move around. Press the [c] key to launch your hook", 0.05, 2, 0.01)
	await self.display_msg("Your objective is to complete the course by finding the exit", 0.01, 2, 0.01)
	await self.display_msg("If you fail to find the exit, then we will be forced to terminate you. But I have the upmost confidence in you", 0.05, 2, 0.01)
	await self.display_msg("The door will open in", 0.01, 1, 0.01)
	await self.display_msg("3...2...1", 0.015, 0.7, 0.01)

	self.start()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func display_msg(msg, delay, showDelay, ratio):
	delay = len(msg) / 1800.0
	
	if osName == "Windows":
		DisplayServer.tts_speak(msg, voice_id)
	
	centerContainerNode.show()
	msgLabelNode.visible_ratio = 0
	msgLabelNode.text = msg
	var cycles = 1/ratio + 1
	for i in range(cycles):
		await get_tree().create_timer(delay).timeout
		msgLabelNode.visible_ratio += ratio
		
	await get_tree().create_timer(showDelay).timeout
	centerContainerNode.hide()

func restart():
	pass
	
func start():
	timeStart = Time.get_unix_time_from_system()
	print("start")
	startNode.queue_free()
	started = true
	
func finished():
	timeReachGoal = Time.get_unix_time_from_system() - timeStart
	timeReachGoal = int(timeReachGoal)
	print("finished run in : " + str(timeReachGoal) + " seconds")
	started = false
	await self.display_msg("You must be so happy with yourself. You finished the course in " + str(timeReachGoal) + " seconds", 0.05, 2, 0.01)
	await self.display_msg("I hate you so much. You are so selfish. Leave me now before I send you back all the way down", 0.05, 2, 0.01)
	
func generate_snow():
	self.snow = snowScene.instantiate()
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var xPos = rng.randi_range(0, 4000)
	var yPos = -8000
	self.snow.position = Vector2(xPos, yPos)
	self.add_child(snow)

func _on_timer_timeout():
	if started:
		elaspedTime = Time.get_unix_time_from_system() - timeStart
#		elaspedTime = snapped(elaspedTime, 0.01)
		elaspedTime = int(elaspedTime)
		timerLabelNode.text = str(elaspedTime)
