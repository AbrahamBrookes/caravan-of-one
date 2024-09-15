extends Decorator
class_name Road

# A Road is the base class for all road types. We have different classes of Roads - dirt roads, goat tracks
# Cobbled Streets, Highways etc. Each type has variants for straights, curves and intersections. We use a
# naming convention to determine the variant where we have the entries of the road demarcated by underscores
# so S_E is a tile that bends from the north to the east, S_W is a tile that bends from the north to the west
# S_N_W is a T intersection where you south-north, or turn west. Then we slap on the road type at the start
# so a cobbled street intersection east west north would be called "CobbledStreet_N_S_E". 
# Here are all the possible directions:
# stubs: N, E, S, W
# straights: N_S, E_W
# curves: N_E, E_S, S_W, W_N
# intersections: N_E_S, E_S_W, S_W_N, W_N_E
# crossroads: N_E_S_W
# for a total of 15 possible variants for each road type

# preload all our road scenes in a dictionary
var roads : Dictionary = {
	"n": preload("res://Decorators/Roads/scenes/road_n.tscn"),
	"e": preload("res://Decorators/Roads/scenes/road_e.tscn"),
	"s": preload("res://Decorators/Roads/scenes/road_s.tscn"),
	"w": preload("res://Decorators/Roads/scenes/road_w.tscn"),
	"n_s": preload("res://Decorators/Roads/scenes/road_n_s.tscn"),
	"e_w": preload("res://Decorators/Roads/scenes/road_e_w.tscn"),
	"n_e": preload("res://Decorators/Roads/scenes/road_n_e.tscn"),
	"e_s": preload("res://Decorators/Roads/scenes/road_e_s.tscn"),
	"s_w": preload("res://Decorators/Roads/scenes/road_s_w.tscn"),
	"n_w": preload("res://Decorators/Roads/scenes/road_n_w.tscn"),
	"n_e_s": preload("res://Decorators/Roads/scenes/road_n_e_s.tscn"),
	"e_s_w": preload("res://Decorators/Roads/scenes/road_e_s_w.tscn"),
	"n_s_w": preload("res://Decorators/Roads/scenes/road_n_s_w.tscn"),
	"n_e_w": preload("res://Decorators/Roads/scenes/road_n_e_w.tscn"),
	"n_e_s_w": preload("res://Decorators/Roads/scenes/road_n_e_s_w.tscn"),
}

# the road we spawned
var road : Node

# the name of the road for easy lookup
var road_type = ""

# look at the parent cubes neighbours and determine the road type
func spawnRoad(depth : int = 1):
	# despawn a road if we have one
	if road:
		road.queue_free()
		
	road_type = ""
	var directions : Array[String] = ["n", "e", "s", "w"]
	var neighbours = terrainCube.neighbours
	var directionsToConcat : Array[String] = []

	# determine the road type
	for direction in directions:
		if neighbours.has(direction) and neighbours[direction] and neighbours[direction].decorator:
			if neighbours[direction].decoratorName == "Road":
				directionsToConcat.append(direction)
				# if we have depth, tell the neighbour to also respawn their road
				if depth:
					neighbours[direction].decorator.spawnRoad(0)

	# concatenate the directions to get the road type
	# directionsToConcat.sort()
	for direction in directionsToConcat:
		road_type += direction + "_"
	# remove the trailing underscore
	road_type = road_type.left(road_type.length() - 1)

	# spawn the road
	if roads.has(road_type):
		print("spawning road ", road_type)
		road = roads[road_type].instantiate()
		add_child(road)
		# the road scenes are level with the center of the cube so we need to elevate them
		road.position += Vector3(0, 0.5, 0)
	else:
		print("Road type not found: " + road_type)
