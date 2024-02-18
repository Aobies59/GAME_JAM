extends Node3D

const INITIAL_TARGET_NUMBER = 5
const MAX_TARGET_NUM = 8
var used_target_positions = []
var targets = []
var target_num: int
var rng = RandomNumberGenerator.new()

const target_positions = \
[Vector3(-1.208, 1.74, -1.467), Vector3(-0.608, 1.74, -1.467), Vector3(-0.008, 1.74, -1.467), Vector3(0.592, 1.74, -1.467), Vector3(1.192, 1.74, -1.467), \
Vector3(-1.208, 1.253, -1.467), Vector3(-0.608, 1.253, -1.467), Vector3(-0.008, 1.253, -1.467), Vector3(0.592, 1.253, -1.467), Vector3(1.192, 1.253, -1.467), \
Vector3(-1.208, 0.766, -1.467), Vector3(-0.608, 0.766, -1.467), Vector3(-0.008, 0.766, -1.467), Vector3(0.592, 0.766, -1.467), Vector3(1.192, 0.766, -1.467)]

@onready var target = preload("res://puzzles/puzzle_2/target.tscn")
@onready var bad_target = preload("res://puzzles/puzzle_2/BadTarget.tscn")

func _ready():
	target_num = INITIAL_TARGET_NUMBER
	generate_targets(INITIAL_TARGET_NUMBER)
	Broadcast.listen("reload_button_press", self, "_on_button_press")
	Broadcast.listen("target_hit", self, "_on_hit")
	Broadcast.listen("round_advance", self, "_on_round_advance_received")
	Broadcast.listen("bad_target_hit", self, "_on_bad_target_hit_received")
	
func _on_hit(_params):
	PlayerInfo.victory = get_round_state()
	if PlayerInfo.victory:
		round_number -= 1
		if round_number <= 0:
			PlayerInfo.shooting_finished = true
		Broadcast.send("disable_round_timer")
	
func _on_button_press(_params):
	for child in $Targets.get_children():
		child.get_up()
		
var round_number = 3
func _on_round_advance_received(_params):
	PlayerInfo.wait_time -= 2.35
	var target_number = rng.randi_range(5, MAX_TARGET_NUM)
	target_num = target_number
	generate_targets(target_number)
	PlayerInfo.bullets_to_give = target_num - 1 # give the bullet the exact number of bullets he will need
	
func _on_bad_target_hit_received(_params):
	generate_targets(INITIAL_TARGET_NUMBER)
	round_number = 3
	PlayerInfo.wait_time = 7.0
	
func get_round_state():
	for child in $Targets.get_children():
		if not child.hit and not child.name.begins_with("TargetBad"):
			return false
	return true

func generate_targets(target_number):
	# remove all targets
	for child in $Targets.get_children():
		child.queue_free()
	# clear used positions
	used_target_positions = []
	# generate all targets in different valid positionsw
	for i in range(target_number-1):
		var temp_target = target.instantiate()
		var first = true
		var position_to_use: Vector3
		while position_to_use in used_target_positions or first:  # generate a new position not in use
			first = false
			position_to_use = target_positions[rng.randi_range(0, len(target_positions) - 1)]
		used_target_positions.append(position_to_use)
		temp_target.position = position_to_use
		$Targets.add_child(temp_target)
	var bad_target_position: Vector3
	var first_time = true
	var temp_bad_target = bad_target.instantiate()
	while bad_target_position in used_target_positions or first_time:  # generate a new position not in use
			first_time = false
			bad_target_position = target_positions[rng.randi_range(0, len(target_positions) - 1)]
	used_target_positions.append(bad_target_position)
	temp_bad_target.position = bad_target_position
	$Targets.add_child(temp_bad_target)


func _on_collectable_respawner_body_entered(body):
	if body.name.begins_with("collectable"):
		body.position = Vector3(-1.1, 1.16, -4.5)
