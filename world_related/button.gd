extends "res://world_related/interactables_and_collectables.gd"
var interactable = true
var inventory_space = 4

func _ready():
	super._ready()
	$MeshInstance3D2/AnimationPlayer.animation_finished.connect(_animation_finished)
	self.name = "interactable_button"
	floor_height = 0.507
	
func interact(player):
	interactable = false
	$MeshInstance3D2/AnimationPlayer.play("press_button")
	player.display_popup("beware")

func _animation_finished(anim_name):
	if anim_name == "press_button":
		interactable = true

func _on_visible_on_screen_notifier_3d_screen_entered():
	if self not in CloseObjects.objects_in_view:
		CloseObjects.objects_in_view.append(self)


func _on_visible_on_screen_notifier_3d_screen_exited():
	if self in CloseObjects.objects_in_view:
		CloseObjects.objects_in_view.remove_at(CloseObjects.objects_in_view.find(self))
