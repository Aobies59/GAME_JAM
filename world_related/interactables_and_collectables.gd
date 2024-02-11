extends Node

var collectable_name: String
var interactable = true

func _on_visible_on_screen_notifier_3d_screen_entered():
	if self not in CloseObjects.objects_in_view:
		CloseObjects.objects_in_view.append(self)

func _on_visible_on_screen_notifier_3d_screen_exited():
	if self in CloseObjects.objects_in_view:
		CloseObjects.objects_in_view.remove_at(CloseObjects.objects_in_view.find(self))
