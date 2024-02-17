extends "res://world_related/interactables_and_collectables.gd"


# Called when the node enters the scene tree for the first time.
func _ready():
	Broadcast.listen("hammer_hit", self, "_on_hammer_hit")


func _on_hammer_hit(params):
	var power = params["power"]
	if power > 1 and power < 1.1:
		print("Perfect Hit!")
