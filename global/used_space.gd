extends Node


var used_spaces: Array
# "aabb" = AABB, position = Vector3
	
func append_space(space: AABB, position: Vector3):
	var space_to_append = {"aabb": space, "position": position}
	if space_to_append not in used_spaces:
		used_spaces.append(space_to_append)

func remove_space(space: AABB, position: Vector3):
	var space_to_append = {"aabb": space, "position": position}
	if space_to_append in used_spaces:
		used_spaces.remove_at(used_spaces.find(space_to_append))

func position_is_free(test_position: Vector3):
	var ray_origin = test_position
	for space in used_spaces:
		var ray_direction = space["position"] - ray_origin
		if space["aabb"].intersects_ray(ray_origin, ray_direction):
			return false
	return true
