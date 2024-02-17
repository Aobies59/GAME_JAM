extends CharacterBody3D

func _ready():
	hammer_timer.autostart = false
	hammer_timer.one_shot = true
	hammer_timer.timeout.connect(swing_hammer)
	add_child(hammer_timer)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	name = "Player"
	connect_broadcast_messages()
	
func connect_broadcast_messages():
	Broadcast.listen("congrats", self, "_on_congrats_message_received")
	Broadcast.listen("round_advance", self, "_on_advance_round_received")
	Broadcast.listen("timeout", self, "_on_timeout_message_received")
	Broadcast.listen("drop", self, "_on_drop_message_received")
	Broadcast.listen("sun_visible", self, "_on_sun_visible_received")
	
func _on_congrats_message_received(_params):
	display_popup("Congrats!")
	
func _on_timeout_message_received(_params):
	display_popup("Out of time!")
	
func _on_drop_message_received(params):
	$HUD.drop(params["position"], true)
	
func _on_sun_visible_received(_params):
	display_popup("When looking at the sun,\npress E with an object\n in hand to present it to him")
	
func _on_advance_round_received(_params):
	display_popup("Next Round!")
	
var speed = 5.0
var interactable_object = null
func _process(_delta):
	handle_other_inputs()
	handle_interact_inputs()
	# update speed based on player state
	speed = get_speed()
	$CamRoot.position.y = get_player_height()
		
	interactable_object = get_interactable_object()
		
	update_hud_object_visibility()
	
	Windows.click_position = get_viewport().get_mouse_position()
	
@onready var objects_in_hand = $CamRoot.get_children()
func update_hud_object_visibility():
	# update the item in the bottom left's visibility
	for object in objects_in_hand:
		if is_instance_of(object, Camera3D):
			continue
		if CloseObjects.object_in_hand == null:
			object.visible = false
			continue
		if object.collectable_name == CloseObjects.object_in_hand:
			object.visible = true
		else:
			object.visible = false	

func get_interactable_object():
	# if there is a body both close and in view, it is interactable
	for body in CloseObjects.objects_close:
		if body in CloseObjects.objects_in_view:
			if body.name.begins_with("interactable") and body.interactable:
				$HUD.hide_use_hud()
				$HUD.display_interact_hud()
				return body
			elif body.name.begins_with("collectable") and inventory_space > 0:
				$HUD.hide_interact_hud()
				$HUD.display_use_hud()
				return body
			elif body.name.begins_with("pseudo_interactable"):
				$HUD.hide_use_hud()
				$HUD.hide_interact_hud()
				return body
			
	# if there is no interactable object, hide the interact hud
	$HUD.hide_interact_hud()
	$HUD.hide_use_hud()
	return null
	
@onready var bullet = preload("res://player_related/bullet.tscn")
func shoot():
	if CloseObjects.object_in_hand != "Gun":
		return
	if $CamRoot/collectable_gun.is_firing:
		return
	PlayerInfo.bullets -= 1
	$CamRoot/collectable_gun.shoot()
	var temp_bullet = bullet.instantiate()
	temp_bullet.position = $CamRoot/Camera3D.global_transform.origin
	temp_bullet.assign_direction($CamRoot/Camera3D.global_transform.basis.z.normalized())
	get_parent().add_child(temp_bullet)
	
var clicking = false
var hammer_in_use = false
var hammer_timer = Timer.new()
func handle_other_inputs():
	update_player_state()

	# TODO: pause menu
	if Input.is_action_just_pressed("escape"):
		get_tree().quit()
		
	if Input.is_action_pressed("click"):
		if PlayerInfo.bullets > 0 and CloseObjects.object_in_hand == "Gun":
			shoot()
			
	if Input.is_action_just_pressed("click"):
		clicking = true
		if CloseObjects.object_in_hand == "Hammer":
			hammer_in_use = true
			hammer_timer.stop()
			hammer_timer.wait_time = 0.5
			hammer_timer.start()
			$HUD.start_loading_hammer()
			
	if Input.is_action_just_released("click"):
		clicking = false
		if hammer_in_use:
			var power = 1.2 - hammer_timer.time_left
			swing_hammer(power)
		
	scroll_inventory_slots()
	
func swing_hammer(power = 1.2):
	$HUD.stop_loading_hammer()
	hammer_in_use = false
	hammer_timer.stop()
	$CamRoot/collectable_hammer.swing()
	if interactable_object != null and interactable_object.name.begins_with("pseudo_interactable_strength_tester"):
		Broadcast.send("hammer_hit", {"power": power})

var inventory_space = 4
var objects_in_front: Array
func handle_interact_inputs():
	if Input.is_action_just_pressed("interact") and interactable_object != null:
	# if the object is interactable, interact with it
		if interactable_object.name.begins_with("interactable") and interactable_object.interactable:
			interactable_object.interact()
		
		# if the object is collectable, try to collect it
		if interactable_object.name.begins_with("collectable") and inventory_space > 0:
			# only update the inventory space if the object was collected succesfully
			if $HUD.collect(interactable_object) == 0:
				inventory_space -= 1
			
	# handle second interact button
	if Input.is_action_just_pressed("interact2") and len(objects_in_front) == 0 and is_on_floor():
		var relative_position = self.position - $CamRoot/Camera3D.get_global_transform().basis.z
		# only update the inventory space if the object was dropped succesfully
		if $HUD.drop(relative_position) == 0:
			inventory_space += 1

# player state variables
var crouching = false
var running = false
func update_player_state():
	# update crouching state
	if Input.is_action_pressed("crouch") and not running and is_on_floor():
		crouching = true
	else:
		crouching = false
		
	# update running state
	if Input.is_action_pressed("run") and not crouching and is_on_floor():
		running = true
	else:
		running = false

func scroll_inventory_slots():
	# scroll between inventory slots
	if Input.is_action_just_pressed("ScrollUp"):
		$HUD.move_selected_slot_left()
		
	if Input.is_action_just_pressed("ScrollDown"):
		$HUD.move_selected_slot_right()

const WALK_SPEED = 5.0
const RUN_SPEED = 10.0
const CROUCH_SPEED = 2.5
const JUMP_VELOCITY = 4.5
func get_speed():
	# return speed according to player's state
	if not running and not crouching:
		return WALK_SPEED
	elif running:
		return RUN_SPEED
	elif crouching:
		return CROUCH_SPEED
		
func get_player_height():
	# return CamRoot's height according to player's state
	if not crouching:
		return 1
	else:
		return 0.6

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	var input_dir = Input.get_vector("left", "right", "forward", "backwards")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)

	move_and_slide()

var MOUSE_SENSITIVITY = 0.1
func _input(event):
	# handle camera movement with mouse motion
	if event is InputEventMouseMotion and not Windows.popup_open:
		$CamRoot.rotate_x(deg_to_rad(event.relative.y) * MOUSE_SENSITIVITY * -1)
		$CamRoot.rotation_degrees.x = clamp($CamRoot.rotation_degrees.x, -75, 75)
		self.rotate_y(deg_to_rad(event.relative.x) * MOUSE_SENSITIVITY * -1)

func display_popup(popup_name):
	$HUD.display_popup(popup_name)

func _on_object_around_body_entered(body):
	if body not in CloseObjects.objects_close:
		CloseObjects.objects_close.append(body)

func _on_object_around_body_exited(body):
	if body in CloseObjects.objects_close:
		CloseObjects.objects_close.remove_at(CloseObjects.objects_close.find(body))

func _on_object_in_front_body_entered(body):
	if body not in objects_in_front and body.name != "Player":
		objects_in_front.append(body)

func _on_object_in_front_body_exited(body):
	if body in objects_in_front:
		objects_in_front.remove_at(objects_in_front.find(body))
