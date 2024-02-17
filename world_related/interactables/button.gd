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
	Broadcast.listen("disable_round_timer", self, "_on_disable_round_timer_received")
	
func _on_disable_round_timer_received(_params):
	timer.stop()
	timer.wait_time = 0.01
	timer.start()
	
func interact():
	timer.stop()
	timer.wait_time = PlayerInfo.wait_time
	timer.start()
	interactable = false
	$MeshInstance3D2/AnimationPlayer.play("press_button")
	PlayerInfo.bullets = PlayerInfo.bullets_to_give
	PlayerInfo.victory = false
	Broadcast.send("reload_button_press")
	
func _on_timer_end():
	if PlayerInfo.victory and not PlayerInfo.shooting_finished:
		round_advance()
	elif PlayerInfo.shooting_finished:
		victory()
	else:
		Broadcast.send("timeout")
		PlayerInfo.bullets = 0

func _animation_finished(anim_name):
	if anim_name == "press_button" and not PlayerInfo.shooting_finished:
		interactable = true

func round_advance():
	Broadcast.send("round_advance")

func victory():
	Broadcast.send("congrats")
	interactable = false
	# TODO: give morse code to the player
