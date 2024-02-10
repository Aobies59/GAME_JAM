extends Control

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_pressed("click"):
		Windows.mouse_clicked = true
	else:
		Windows.mouse_clicked = false
		
	Windows.click_position = get_viewport().get_mouse_position()

var distance_to_center = Vector2(134, 0)
