extends "res://world_related/interactables_and_collectables.gd"
var active = false

# Called when the node enters the scene tree for the first time.
func _ready():
	name = "collectable_puzzle_orb"
	collectable_name = "Puzzle_orb"
	
func _process(_delta):
	self.gravity_scale = 1 if active else 0
	if self.position.y < -0.4:
		self.position.y = -0.4
	
func _on_area_3d_body_entered(body):
	if body.name.begins_with("Barrier") and active:
		self.reset()
		
func activate():
	print("activated")
	active = true

func reset():
	print("reset")
	self.position = Vector3(0, 2.29, 0)
	active = false
