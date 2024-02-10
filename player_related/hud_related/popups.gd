extends Node

var popup_open = true

var distance_to_center = Vector2(self.size.x/2, 0)

const POPUPS_MARGIN = 20
func _input(event):
	if not popup_open:
		return
	if event is InputEventMouseMotion and Windows.mouse_clicked and Windows.click_position.distance_to(self.position + distance_to_center) < 100:
		var position_to_assign = Windows.click_position - distance_to_center
		position_to_assign.x = clamp(position_to_assign.x, POPUPS_MARGIN, get_viewport().size.x - POPUPS_MARGIN - self.size.x)
		position_to_assign.y = clamp(position_to_assign.y, POPUPS_MARGIN, get_viewport().size.y - POPUPS_MARGIN - self.size.y)
		self.position = position_to_assign
