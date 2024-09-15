extends Node
class_name Town

# The Town is not a decorator itself, rather it is a thing to keep track of the goings on in a town.

# a reference to the regions PromaryIndustrySpawner
var spawner : PrimaryIndustrySpawner

# a dictionary to keep track of all the decorators in the town
var decorators : Dictionary = {
	"TownCenter": [],
	"Road": [],
	"House": [],
	"Marketplace": [],
	"Blacksmith": [],
}

func initialSpawn():
	# spawn a TownCenter node and a road next to it
	var townCenter = spawner.spawnTown()
	decorators["TownCenter"].append(townCenter)
	
	townCenter.neighbours["w"].spawnDecorator("Road")
	townCenter.neighbours["w"].decorator.spawnRoad()
	decorators["Road"].append(townCenter.neighbours["w"])
	
	decorators["Road"][0].neighbours["w"].spawnDecorator("Road")
	decorators["Road"][0].neighbours["w"].decorator.spawnRoad()
	decorators["Road"].append(decorators["Road"][0].neighbours["w"])
	
	decorators["Road"][1].neighbours["n"].spawnDecorator("Road")
	decorators["Road"][1].neighbours["n"].decorator.spawnRoad()
	decorators["Road"].append(decorators["Road"][1].neighbours["n"])
	
	decorators["Road"][2].neighbours["n"].spawnDecorator("Road")
	decorators["Road"][2].neighbours["n"].decorator.spawnRoad()
	decorators["Road"].append(decorators["Road"][2].neighbours["n"])
	
	decorators["Road"][3].neighbours["w"].spawnDecorator("Road")
	decorators["Road"][3].neighbours["w"].decorator.spawnRoad()
	decorators["Road"].append(decorators["Road"][3].neighbours["w"])
	
	for i in range(128):
		grow()
	
	

# grow the town by spawning a new decorator attached to a road, or spawn a new road
func grow():
	# query all the roads to find one with a spare neighbour to its side. The name of the road tells
	# which compass directions are acessed into the road, so check the road name and only spawn a
	# decorator on a non-access side of the road
	
	# in order to avoid having a lack of roads to spawn on, we'll require at least 3 spare road spots
	var num_spare = 0
	
	for road in decorators["Road"]:
		var road_name = road.decorator.road_type
		# fudge the road name so that if it's stub it's not a stub
		if road_name == "s":
			road_name = "s_n"
		if road_name == "e":
			road_name = "e_w"
		if road_name == "n":
			road_name = "n_s"
		if road_name == "w":
			road_name = "w_e"

		var road_directions = road_name.split("_") # for a s_e road, this would be ["s", "e"]
		var road_neighbours = road.neighbours
		var compass_directions = ["n", "e", "s", "w"]
		compass_directions.shuffle()
		for direction in compass_directions:
			if direction not in road_directions: # we are looking at the non-access side of the road
				if road_neighbours[direction] and not road_neighbours[direction].decorator: # space is free
					num_spare += 1
					if num_spare < 6:
						continue
					# spawn a new decorator
					var new_decorator = road_neighbours[direction].spawnDecorator("House")
					# add the new decorator to the town's list of decorators
					decorators["House"].append(new_decorator)
					return
	
	# if we got here then we couldn't find a place to spawn a house so spawn a road instead
	for road in decorators["Road"]:
		for neighbour in road.neighbours:
			if road.neighbours[neighbour] and not road.neighbours[neighbour].decorator:
				road.neighbours[neighbour].spawnDecorator("Road")
				road.neighbours[neighbour].decorator.spawnRoad()
				decorators["Road"].append(road.neighbours[neighbour])
				return
	
