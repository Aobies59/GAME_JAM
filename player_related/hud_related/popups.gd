extends Sprite2D

var popup_open = true

func _on_close_button_pressed():
	$"..".hide_popup()


func _on_ok_button_pressed():
	$"..".hide_popup()
