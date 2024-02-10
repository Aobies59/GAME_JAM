extends StaticBody3D
var interactable = true

func _ready():
	$MeshInstance3D2/AnimationPlayer.animation_finished.connect(_animation_finished)
	self.name = "button"
	
func interact():
	interactable = false
	$MeshInstance3D2/AnimationPlayer.play("press_button")

func _animation_finished(anim_name):
	if anim_name == "press_button":
		interactable = true

func _on_visible_on_screen_notifier_3d_screen_entered():
	if self not in CloseObjects.objects_in_view:
		CloseObjects.objects_in_view.append(self)


func _on_visible_on_screen_notifier_3d_screen_exited():
	if self in CloseObjects.objects_in_view:
		CloseObjects.objects_in_view.remove_at(CloseObjects.objects_in_view.find(self))
