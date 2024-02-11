extends "res://world_related/interactables_and_collectables.gd"

var left = false

# Called when the node enters the scene tree for the first time.
func _ready():
	name = "interactable_puzzle_toggle"
	$"../Group_Barriers/AnimationPlayer".animation_finished.connect(_on_animation_finished)
	
func _process(_delta):
	if get_node("../").get_children()[-1].name != "collectable_puzzle_orb":
		interactable = false

func interact(_player):
	interactable = false
	if not get_node("../").get_children()[-1].active:
		get_node("../").get_children()[-1].activate()
	if left:
		move_right()
	else:
		move_left()

func move_left():
	$"../Group_Barriers/AnimationPlayer".play("MoveLeft")
	left = true
	
func move_right():
	$"../Group_Barriers/AnimationPlayer".play("MoveRight")
	left = false
	
func _on_animation_finished(anim_name):
	if anim_name.begins_with("Move"):
		interactable = true
	
