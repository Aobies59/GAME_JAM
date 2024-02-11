extends Control

var popups: Dictionary
func _ready():
	popups["beware"] = $Beware
	
func _process(_delta):
	update_inventory_hud()
	
@onready var selected_slot_markers = [$InventoryUI/Slot1Selected, $InventoryUI/Slot2Selected,\
 $InventoryUI/Slot3Selected, $InventoryUI/Slot4Selected]
@onready var full_slot_markers = [$InventoryUI/Slot1Full, $InventoryUI/Slot2Full, $InventoryUI/Slot3Full,\
 $InventoryUI/Slot4Full]
var selected_slot = 0
func update_inventory_hud():
	for i in range(4):
		if i == selected_slot:
			selected_slot_markers[i].visible = true
		else:
			selected_slot_markers[i].visible = false

var open_popup: Sprite2D = null
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

var inventory = [null, null, null, null]
var inventory_names = [null, null, null, null]
func move_selected_slot_right():
	selected_slot = 0 if selected_slot == 3 else selected_slot + 1
	CloseObjects.object_in_hand = inventory_names[selected_slot]
	
func move_selected_slot_left():
	selected_slot = 3 if selected_slot == 0 else selected_slot - 1
	CloseObjects.object_in_hand = inventory_names[selected_slot]

# preloaded objects to drop on the floor
var collectables = {"Orb": preload("res://world_related/collectables/test_collectable.tscn"), "Chair": preload("res://world_related/collectables/temp_chair.tscn")}
func collect(item):
	# CloseObjects.object_in_hand = object's collectable name
	# inventory[selected_slot] = objects preloaded node
	
	# if selected slot is empty, store the object there
	if inventory[selected_slot] == null:
		inventory[selected_slot] = collectables[item.collectable_name]
		inventory_names[selected_slot] = item.collectable_name
		CloseObjects.object_in_hand = item.collectable_name
		display_collected_item(selected_slot)
		item.queue_free()
		return
	
	# if selected slot is not empty, store the object in the first empty slot
	for i in range(4):
		if inventory[i] == null:
			inventory[i] = collectables[item.collectable_name]
			inventory_names[i] = item.collectable_name
			CloseObjects.object_in_hand = item.collectable_name
			display_collected_item(i)
			item.queue_free()
			return 0
			
	# if the item was not collected succesfully, return error state
	return -1

func drop(relative_position: Vector3):
	# if there is no object in hand, return error state
	if inventory[selected_slot] == null or CloseObjects.object_in_hand == null:
		return -1
	# create the item to spawn in the floor
	var temp_item = inventory[selected_slot].instantiate()
	# item's position is the given position with its own floor height
	temp_item.position = Vector3(relative_position.x, FloorHeight.floor_heights[CloseObjects.object_in_hand], relative_position.z)
	# add the item to the tree
	get_tree().root.add_child(temp_item)
	# hide the item from the inventory hud
	hide_collected_item(selected_slot)
	# set the variables for the item to null
	inventory[selected_slot] = null
	inventory_names[selected_slot] = null
	CloseObjects.object_in_hand = null
	
	return 0

func display_collected_item(item_index):
	full_slot_markers[item_index].visible = true

func hide_collected_item(item_index):
	full_slot_markers[item_index].visible = false
