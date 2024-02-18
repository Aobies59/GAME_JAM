extends "res://world_related/interactables_and_collectables.gd"

func _ready():
	name = "collectable_gacha_ball"
	collectable_name = "Gacha_Ball"
	Broadcast.listen("open_gacha_ball", self, "_on_open_gacha_ball_received")
	
func _on_open_gacha_ball_received(_params):
	self.queue_free()
