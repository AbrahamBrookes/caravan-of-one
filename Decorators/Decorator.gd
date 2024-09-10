extends Node3D
class_name Decorator

# Decorator is a thing that resides at some grid location. Generally a building
# or perhaps something less permanent

# a link to the TerrainCube on which this decorator sits
var terrainCube:TerrainCube

# decorators are clickable
func click():
	print("this decorator does not have a click function implemented")

# Methods for key moments during the day
func daybreak():
	pass

func morning():
	pass

func midday():
	pass

func dusk():
	pass

func evening():
	pass

# a method for dehydrating this scene for serialization
func dehydrate():
	return {
		"name": get_class(),
	}
