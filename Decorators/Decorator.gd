extends Node3D
class_name Decorator

# Decorator is a thing that resides at some grid location. Generally a building
# or perhaps something less permanent

# a link to the TerrainSquare on which this decorator sits
var square:TerrainSquare

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
