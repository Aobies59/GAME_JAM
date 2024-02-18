extends "res://world_related/interactables_and_collectables.gd"
var moving = false
var target_hit = false

# Called when the node enters the scene tree for the first time.
func _ready():
	Broadcast.listen("hammer_hit", self, "_on_hammer_hit")
	$AnimationPlayer.animation_finished.connect(_on_animation_finish)


func _on_hammer_hit(params):
	if moving:
		return
	target_hit = false
	moving = true
	var power = params["power"]
	var subrange_size = 0.5/16.0
	# Calculate the index based on the power value
	var animation_index = 17 - int(power / subrange_size)
	if animation_index == 3:
		target_hit = true
	# Ensure the index stays within the valid range
	animation_index =  clamp(animation_index, 1, 16)
	var str_animation_index: String = str(animation_index)
	if animation_index < 10:
		str_animation_index = "0" + str_animation_index
	$AnimationPlayer.play("UP_" + str_animation_index)

func _on_animation_finish(anim_name):
	moving = false
	if anim_name.begins_with("UP"):
		var anim_index = anim_name.substr(3, anim_name.length() - 1)
		$AnimationPlayer.play("DOWN_" + anim_index)
		moving = true
		if target_hit and get_node("collectable_gacha_ball") != null:
			$collectable_gacha_ball.gravity_scale = 1.0
