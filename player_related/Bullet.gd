extends StaticBody3D


var direction: Vector3
var SPEED = 40.0
var moving = false

func _ready():
	name = "TestBullet"

func _physics_process(delta):
	if moving:
		position += direction * SPEED * delta * -1
	
func assign_direction(direction_to_assign):
	direction = direction_to_assign
	moving = true

func _on_collision_area_body_entered(body):
	if body.name.begins_with("Target"):
		body.get_hit()
		
	if body.name != "Player" and not body.name.begins_with("TestBullet"):
		queue_free()
