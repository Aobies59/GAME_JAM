extends Node2D

var morse_code_text = ""
const MAX_STRING_SIZE = 20
const passwords = {"gunner": "__. .._ _. _. . ._.", "strong": "... _ ._. ___ _. __.",\
"clever": "_._. ._.. . ..._ . ._."}

func update_text():
	$ColorRect/Label.text = morse_code_text
	var all_codes_done = true
	for password in passwords.keys():
		if morse_code_text == passwords[password] and PlayerInfo.codes[password]:
			PlayerInfo.codes[password] = false
			print(password)
		if PlayerInfo.codes[password]:
			all_codes_done = false
	if all_codes_done:
		print("Congrats! All codes done")
			
func append_text(text: String):
	if len(morse_code_text) == MAX_STRING_SIZE:
		return
	morse_code_text += text
	update_text()

func _on_button_pressed():
	# button for the dot
	append_text(".")

func _on_button_2_pressed():
	# button for the slash
	append_text("_")


func _on_del_button_pressed():
	morse_code_text = morse_code_text.substr(0, len(morse_code_text) - 1)
	update_text()

func _on_button_3_pressed():
	append_text(" ")
