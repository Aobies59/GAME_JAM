extends Node

var popup_open = true

var distance_to_center = Vector2(self.size.x/2, 0)

func _input(event):
	if not popup_open:
		return
	if event is InputEventMouseMotion and Windows.mouse_clicked and Windows.click_position.distance_to(self.position + distance_to_center) < 100:
		var position_to_assign = Windows.click_position - distance_to_center
		position_to_assign.x = clamp(position_to_assign.x, 30, 1130 - self.size.x)
		position_to_assign.y = clamp(position_to_assign.y, 27.5, 560 - self.size.y)
		self.position = position_to_assign

func _on_close_button_pressed():
	self.queue_free()
	popup_open = false
