extends Node3D

var point1 = Vector3(1,1,1)
var point2 = Vector3(2,1,1)

# Called when the node enters the scene tree for the first time.
func _ready():
	create_cylinder()
	

func create_cylinder():
	var cylinder_mesh = CylinderMesh.new()
	var cylinder_radius = 0.1
	var cylinder_height = point1.distance_to(point2)
	cylinder_mesh.height = cylinder_height
	cylinder_mesh.top_radius = cylinder_radius
	cylinder_mesh.bottom_radius = cylinder_radius
	
	# calculate the position of the cylinder halfway between the two points
	var cylinder_position = (point1 + point2)/2
	
	# calculate the rotation of the cylinder
	var cylinder_direction = (point2 - point1).normalized()
	var rotation_axis = cylinder_direction.cross(Vector3.UP).normalized()
	var rotation_angle = acos(cylinder_direction.normalized().dot(Vector3.UP))
	var cylinder_rotation = rotation_axis * rotation_angle
	
	var cylinder_instance = MeshInstance3D.new()
	cylinder_instance.mesh = cylinder_mesh
	cylinder_instance.position = cylinder_position
	cylinder_instance.rotation = cylinder_rotation
	
	add_child(cylinder_instance)

