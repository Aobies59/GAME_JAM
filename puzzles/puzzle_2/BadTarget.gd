extends Node3D

var hit = false

func _ready():
	name = "TargetBad"

func get_hit():
	if hit:
		return
	$AnimationPlayer.play("Hit")
	hit = true
	Broadcast.send("bad_target_hit")

func get_up():
	if not hit:
		return
	$AnimationPlayer.play("GetUp")
	hit = false
