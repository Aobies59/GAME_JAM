extends Control

var popups: Dictionary
var open_popup: ColorRect = null

func _ready():
	popups["mujeres_cachondas"] = $mujeres_cachondas
	popups["beware"] = $beware

func display_popup(popup_name):
	if popups[popup_name] == null:
		return
	Windows.popup_open = true
	popups[popup_name].visible = true
	open_popup = popups[popup_name]
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
func hide_popup():
	if open_popup == null:
		return
	Windows.popup_open = false
	open_popup.visible = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	open_popup = null

func display_interact_hud():
	$Interact.visible = true
	
func hide_interact_hud():
	$Interact.visible = false
