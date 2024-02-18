extends Node2D

func _ready():
	await get_tree().create_timer(5.0).timeout
	$ColorRect.visible = true


func _on_button_pressed():
	get_tree().change_scene_to_file("res://scenes/room_marc.tscn")
