extends Node2D

var morse_code_text = ""
const MAX_STRING_SIZE = 12
const password = ".._..__."


func _process(_delta):
	$ColorRect/Label.text = morse_code_text
	if morse_code_text == password:
		get_tree().change_scene_to_file("res://scenes/room_marc.tscn")

func append_text(text: String):
	if len(morse_code_text) == MAX_STRING_SIZE:
		return
	morse_code_text += text

func _on_button_pressed():
	# button for the dot
	append_text(".")

func _on_button_2_pressed():
	# button for the slash
	append_text("_")


func _on_del_button_pressed():
	morse_code_text = morse_code_text.substr(0, len(morse_code_text) - 1)
