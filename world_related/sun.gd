extends MeshInstance3D
var first_time = true
var active = false
var object_requested
var possible_objects = {1: ["Chair", "Hammer", "Rubiks_Cube", "Pen"], 2: ["Gun", "Lamp"], 3: ["Gun"], 4: ["Gun"]}
var object_names = {"Rubiks_Cube": "Rubiks Cube"}
var start_timer = Timer.new()
var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	Broadcast.listen("present_object", self, "_on_present_object_received")
	Broadcast.listen("pause", self, "_on_pause_recieved")
	Broadcast.listen("unpause", self, "_on_unpause_received")
	start_timer.autostart = false
	start_timer.one_shot = true
	start_timer.wait_time = 5.0
	start_timer.timeout.connect(request_item)
	add_child(start_timer)
	start_timer.start()
	
func _on_pause_recieved(_params):
	start_timer.set_paused(true)
	
func _on_unpause_received(_params):
	start_timer.set_paused(false)

var MOVEMENT_SPEED = 4.0
var SCALE_SPEED = 0.965
func _process(delta):
	if active and not PlayerInfo.paused and not Windows.popup_open:
		position.y -= MOVEMENT_SPEED * delta
		scale *= SCALE_SPEED ** (delta)

func _on_visible_on_screen_notifier_3d_screen_entered():
	if first_time:
		first_time = false
		Broadcast.send("sun_visible")

func _on_player_killer_body_entered(body):
	if body.name == "Player":
		get_tree().quit()

func _on_present_object_received(params):
	var object_received = params["object"]
	if object_received == object_requested and active:
		Broadcast.send("correct_object")
		if PlayerInfo.round_number == 4:
			PlayerInfo.round_number = 1
		else:
			PlayerInfo.round_number += 1
		reset()
		
func reset():
	start_timer.start()
	active = false
	position = Vector3(2.585, 103.923, -5.412)
	scale = Vector3(15, 15, 15)

func request_item():
	active = true
	var objects_list = possible_objects[PlayerInfo.round_number]
	var random_number = rng.randi_range(0, len(objects_list) - 1)
	object_requested = objects_list[random_number]
	var object_name: String
	if object_requested not in object_names.values():
		object_name = object_requested
	else:
		object_name = object_names[object_requested]
	Broadcast.send("request_object", {"object": object_name})
