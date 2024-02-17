extends "res://world_related/interactables_and_collectables.gd"

func _ready():
	name = "interactable_altar"
	
var object_to_collect: String
func _process(_delta):
	interactable = true if CloseObjects.object_in_hand == object_to_collect else false

func interact(player):
	# try to drop the objet in its position
	Broadcast.send("drop", {"position": self.position})
