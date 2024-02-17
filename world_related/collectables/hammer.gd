extends "res://world_related/interactables_and_collectables.gd"

var in_use = false
func _ready():
	name = "collectable_hammer"
	collectable_name = "Hammer"
	$AnimationPlayer.animation_finished.connect(_on_animation_finish)
	
func _on_animation_finish(anim_name):
	if anim_name == "Swing":
		in_use = false

func swing():
	$AnimationPlayer.play("Swing")
	in_use = true
