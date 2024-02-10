extends Node


var used_spaces: Array
# {"collision_shape" = CollisionShape3D, position = Vector3
	
func append_space(space: CollisionShape3D):
	if space not in used_spaces:
		used_spaces.append(space)

func remove_space(space: CollisionShape3D):
	if space in used_spaces:
		used_spaces.remove_at(used_spaces.find(space))

func position_is_free(test_space: CollisionShape3D):
	var transform1 = test_space.global_transform
	for space in used_spaces:
		var transform2 = space.global_transform
		if test_space.shape.get_aabb(test_space.global_transform).intersects(space.shape, transform1, transform2):
			return false
	return true
