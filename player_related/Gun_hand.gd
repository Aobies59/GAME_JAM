extends Node3D

var is_firing = false
var collectable_name = "Gun"
@onready var animation_player = $AnimationPlayer

func _ready():
	animation_player.animation_finished.connect(_on_animation_finish)

func _on_animation_finish(anim_name):
	if anim_name == "Shoot":
		is_firing = false

func shoot():
	is_firing = true
	animation_player.play("Shoot")
