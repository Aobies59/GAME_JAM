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

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func _process(_delta):
	handle_other_inputs()
	# update speed based on player state
	speed = get_speed()
	$CamRoot.position.y = get_player_height()
	if Input.is_action_pressed("click"):
		Windows.mouse_clicked = true
	else:
		Windows.mouse_clicked = false
		
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
		
	if Input.is_action_just_pressed("interact") and not Windows.popup_open:
		$HUD.display_popup("beware")
		
	if Input.is_action_just_pressed("escape"):
		get_tree().quit()
		
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
