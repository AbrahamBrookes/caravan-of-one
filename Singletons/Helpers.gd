extends Node

# convert a vector to a primary compass direction
func get_compass_direction(vec : Vector3) -> String:
	# Use atan2 to find the angle in radians
	var angle = atan2(vec.x, vec.z)

	# Convert angle from radians to degrees for easier understanding
	angle = deg_to_rad(angle)

	# Determine the direction based on angle
	if (angle >= -45 and angle < 45):
		return "N"
	elif (angle >= 45 and angle < 135):
		return "E"
	elif (angle >= -135 and angle < -45):
		return "W"
	else:
		return "S"

# produce a normalized vector representing a compass direction
func compass_step(direction : String) -> Vector3:
	if (direction == "N"):
		return Vector3(0, 0, 1)
	elif (direction == "E"):
		return Vector3(1, 0, 0)
	elif (direction == "W"):
		return Vector3(-1, 0, 0)
	else:
		return Vector3(0, 0, -1)
	
	
