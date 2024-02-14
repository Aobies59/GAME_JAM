extends "res://world_related/interactables_and_collectables.gd"

var player_object
@onready var timer = Timer.new()

func _ready():
	interactable = true
	$MeshInstance3D2/AnimationPlayer.animation_finished.connect(_animation_finished)
	self.name = "interactable_button"
	timer.autostart = false
	timer.timeout.connect(_on_timer_end)
	timer.one_shot = true
	add_child(timer)
	
func interact(player):
	player_object = player
	timer.stop()
	timer.wait_time = 7.0
	timer.start()
	interactable = false
	$MeshInstance3D2/AnimationPlayer.play("press_button")
	PlayerInfo.bullets = 5
	PlayerInfo.score = 0
	
func _on_timer_end():
	if PlayerInfo.score >= 5:
		player_object.display_popup("Congrats!")
		interactable = false
	else:
		player_object.display_popup("Out of time!")
		PlayerInfo.bullets = 0
		PlayerInfo.score = 0

func _animation_finished(anim_name):
	if anim_name == "press_button":
		interactable = true

func _on_visible_on_screen_notifier_3d_screen_entered():
	if self not in CloseObjects.objects_in_view:
		CloseObjects.objects_in_view.append(self)


func _on_visible_on_screen_notifier_3d_screen_exited():
	if self in CloseObjects.objects_in_view:
		CloseObjects.objects_in_view.remove_at(CloseObjects.objects_in_view.find(self))
