extends Resource
class_name TerrainSquareTemplate

# The TerrainSquareTemplate class ins a resource template used as a struct when
# generating the terrain grid. It contains all the information for a given grid
# square. This is then serialized and reloaded.

# the location of this square on the grid
@export var x: int
@export var z: int

# the decorator on this square
@export var decorator: Decorator
