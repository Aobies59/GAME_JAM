extends "res://world_related/interactables_and_collectables.gd"

@onready var timer = Timer.new()

func _ready():
	interactable = true
	$MeshInstance3D2/AnimationPlayer.animation_finished.connect(_animation_finished)
	self.name = "interactable_button"
	timer.autostart = false
	timer.timeout.connect(_on_timer_end)
	timer.one_shot = true
	add_child(timer)
	
func interact():
	timer.stop()
	timer.wait_time = 7.0
	timer.start()
	interactable = false
	$MeshInstance3D2/AnimationPlayer.play("press_button")
	PlayerInfo.bullets = 5
	PlayerInfo.score = 0
	
func _on_timer_end():
	if PlayerInfo.score >= 5:
		Broadcast.send("congrats")
		interactable = false
	else:
		Broadcast.send("timeout")
		PlayerInfo.bullets = 0
		PlayerInfo.score = 0

func _animation_finished(anim_name):
	if anim_name == "press_button":
		interactable = true
