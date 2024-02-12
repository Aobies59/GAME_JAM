extends "res://world_related/interactables_and_collectables.gd"
var active = false

# Called when the node enters the scene tree for the first time.
func _ready():
	name = "collectable_puzzle_orb"
	collectable_name = "Puzzle_orb"
	
func _process(delta):
	if active:
		self.position.y -= 2 * delta
	
func _on_area_3d_body_entered(body):
	if body.name.begins_with("Barrier") and active:
		self.reset()
	if body.name.begins_with("Floor") and active:
		self.position.y += 0.1
		active = false
		
func activate():
	active = true

func reset():
	self.position = Vector3(0, 2.29, 0)
	active = false
