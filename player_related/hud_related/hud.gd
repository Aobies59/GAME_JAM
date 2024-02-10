extends Control

var popups: Dictionary
var open_popup: Sprite2D = null
var inventory = [null, null, null, null]
@onready var selected_slot_markers = [$InventoryUI/Slot1Selected, $InventoryUI/Slot2Selected,\
 $InventoryUI/Slot3Selected, $InventoryUI/Slot4Selected]
@onready var full_slot_markers = [$InventoryUI/Slot1Full, $InventoryUI/Slot2Full, $InventoryUI/Slot3Full, $InventoryUI/Slot4Full]
var selected_slot = 0

func _ready():
	popups["beware"] = $Beware
	
func _process(_delta):
	for i in range(4):
		if i == selected_slot:
			selected_slot_markers[i].visible = true
		else:
			selected_slot_markers[i].visible = false

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

func move_selected_slot_right():
	selected_slot = 0 if selected_slot == 3 else selected_slot + 1
	
func move_selected_slot_left():
	selected_slot = 3 if selected_slot == 0 else selected_slot - 1

func collect(item):
	if inventory[selected_slot] == null:
		inventory[selected_slot] = item
		display_collected_item(selected_slot)
		item.get_node("CollisionShape3D").disabled = true
		item.visible = false
		return
	
	for i in range(4):
		if inventory[i] == null:
			inventory[i] = item
			display_collected_item(i)
			item.visible = false
			break
			
func drop(relative_position: Vector3):
	if inventory[selected_slot] == null:
		return -1
	inventory[selected_slot].position = Vector3(relative_position.x, inventory[selected_slot].floor_height, relative_position.z)
	inventory[selected_slot].visible = true
	inventory[selected_slot].get_node("CollisionShape3D").disabled = false
	hide_collected_item(selected_slot)
	inventory[selected_slot] = null
	return 0

func display_collected_item(item_index):
	full_slot_markers[item_index].visible = true

func hide_collected_item(item_index):
	full_slot_markers[item_index].visible = false
