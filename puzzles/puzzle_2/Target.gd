extends Node3D

var rng = RandomNumberGenerator.new()

var active = true

var left_position
var right_position
var top_position
var bottom_position

func _ready():
	left_position = $TopLeft.position.x
	right_position = $BottomRight.position.x
	top_position = $TopLeft.position.y
	bottom_position = $BottomRight.position.y

func respawn():
	PlayerInfo.score += 1
	var new_position = $TargetBody.position
	while $TargetBody.position.distance_to(new_position) < 3:
		new_position.x = rng.randf_range(left_position, right_position)
		new_position.y = rng.randf_range(bottom_position, top_position)
	active = true
	$TargetBody.position = new_position

func stop():
	active = false
	visible = false
