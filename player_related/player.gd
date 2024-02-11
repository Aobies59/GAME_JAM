extends CharacterBody3D

# speed-related variables
var speed = 5.0
const WALK_SPEED = 5.0
const RUN_SPEED = 10.0
const CROUCH_SPEED = 2.5
const JUMP_VELOCITY = 4.5

var MOUSE_SENSITIVITY = 0.1

# player state variables
var crouching = false
var running = false

var interactable_object = null
var objects_in_front: Array
var inventory_space = 4

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var objects_in_hand = [$CamRoot/Orb]
 
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	name = "Player"
	
func _process(_delta):
	handle_other_inputs()
	# update speed based on player state
	speed = get_speed()
	$CamRoot.position.y = get_player_height()
	if Input.is_action_pressed("click"):
		Windows.mouse_clicked = true
	else:
		Windows.mouse_clicked = false
		
	interactable_object = null
	for body in CloseObjects.objects_close:
		if body in CloseObjects.objects_in_view:
			interactable_object = body
			
	if interactable_object != null:
		$HUD.display_interact_hud()
	else:
		$HUD.hide_interact_hud()
		
	for object in objects_in_hand:
		if CloseObjects.object_in_hand == null:
			object.visible = false
			continue
		if object.collectable_name == CloseObjects.object_in_hand:
			object.visible = true
		else:
			object.visible = false
		
	Windows.click_position = get_viewport().get_mouse_position()
	
func handle_other_inputs():
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
		
	if Input.is_action_just_pressed("interact") and interactable_object != null:
		# if the object is interactable, interact with it
		if interactable_object.name.begins_with("interactable") and interactable_object.interactable:
			interactable_object.interact(self)
			
		# if the object is collectable, try to collect it
		if interactable_object.name.begins_with("collectable") and inventory_space > 0:
			# only update the inventory space if the object was collected succesfully
			if $HUD.collect(interactable_object) == 0:
				inventory_space -= 1
			
	if Input.is_action_just_pressed("interact2") and len(objects_in_front) == 0:
		var relative_position = self.position - $CamRoot/Camera3D.get_global_transform().basis.z
		# only update the inventory space if the object was dropped succesfully
		if $HUD.drop(relative_position) == 0:
			inventory_space += 1
		
	# TODO: pause menu
	if Input.is_action_just_pressed("escape"):
		get_tree().quit()
		
	# scroll between inventory slots
	if Input.is_action_just_pressed("ScrollUp"):
		$HUD.move_selected_slot_left()
		
	if Input.is_action_just_pressed("ScrollDown"):
		$HUD.move_selected_slot_right()
		
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

func _input(event):
	# handle camera movement with mouse motion
	if event is InputEventMouseMotion and not Windows.popup_open:
		$CamRoot.rotate_x(deg_to_rad(event.relative.y) * MOUSE_SENSITIVITY * -1)
		$CamRoot.rotation_degrees.x = clamp($CamRoot.rotation_degrees.x, -75, 75)
		self.rotate_y(deg_to_rad(event.relative.x) * MOUSE_SENSITIVITY * -1)


func _on_area_3d_body_entered(body):
	if body not in CloseObjects.objects_close:
		CloseObjects.objects_close.append(body)


func _on_area_3d_body_exited(body):
	if body in CloseObjects.objects_close:
		CloseObjects.objects_close.remove_at(CloseObjects.objects_close.find(body))

func display_popup(popup_name):
	$HUD.display_popup(popup_name)


func _on_area_3d_2_body_entered(body):
	if body not in objects_in_front and body.name != "Player":
		objects_in_front.append(body)


func _on_area_3d_2_body_exited(body):
	if body in objects_in_front:
		objects_in_front.remove_at(objects_in_front.find(body))
