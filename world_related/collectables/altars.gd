extends "res://world_related/interactables_and_collectables.gd"

var object_to_collect: String
func _ready():
	name = "interactable_altar"
	
func _process(_delta):
	interactable = true if CloseObjects.object_in_hand == object_to_collect else false

func interact(player):
	# try to drop the objet in its position
	if player.get_node("HUD").drop(self.position, true) == 0:
		player.inventory_space += 1
