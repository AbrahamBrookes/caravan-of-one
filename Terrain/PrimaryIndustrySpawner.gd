extends Node
class_name PrimaryIndustrySpawner

# the PrimaryIndustrySpawner is attached to a TerrainCubeRegion and generates primary producers like
# farms, mines and fisheries - these are decorators that are generally the start of any produce chain
# although they do have inputs like fertiliser, tools and bait. This class here will randomly select
# a primary producer and spawn it depending on parameters passed in by its parent TerrainCubeRegion

var terrainSize = 100 # square

# reference to our parent TerrainCubeRegion
var region : TerrainCubeRegion

# each region can only have one type of thingy
var town : TerrainCube
var farm : TerrainCube

func spawnFarm():
	farm = spawnDecorator("Farmhouse", 8, 8)

func spawnTown() -> TerrainCube:
	town = spawnDecorator("TownCenter", 15, 15)
	return town

func spawnDecorator(name: String, bufferX: int, bufferZ: int) -> TerrainCube:
	if not region:
		push_error("PrimaryIndustrySpawner: terrainCubeRegion not set")
		return
	
	# a farm needs at least a 5x5 clear area to place its initial farm plots
	var farmPlaced = false

	# the cube we will place the farm on
	var cube : TerrainCube

	while not farmPlaced:
		# select a random location at least buffer cubes in from the edge
		var x = randi() % (terrainSize - bufferX * 2) + bufferX
		var z = randi() % (terrainSize - bufferZ * 2) + bufferZ

		# check if the area is clear
		for i in range(5):
			for j in range(5):
				cube = region.getCubeAtPosition(Vector3(x + i, 0, z + j))
				if not cube or cube.decorator:
					break
			if not cube or cube.decorator:
				break

		if not cube or cube.decorator:
			continue

		# we have a clear area to place the farm
		farmPlaced = true

		# select the cube at the centre of the farm
		cube = region.getCubeAtPosition(Vector3(x + 2, 0, z + 2))
	
	cube.spawnDecorator(name)
	print("cube", cube)
	return cube

# take two cubes and connect them with a road. This invokes our simple A* algorithm
func connectCubes(a: TerrainCube, b: TerrainCube):
	var reachedDestination = false
	var currentCube = a
	
	# save our path as we go
	var notionalPath : Array[Vector3]
	
	# a list of cubes to blacklist so we never move to them
	var blackList : Array[Vector3]
	
	while not reachedDestination:
		# an array of the current cubes neighbours and their distance to the taget
		var distances : Dictionary
		for compass in currentCube.neighbours:
			var currentNeighbour = currentCube.neighbours[compass]
			# if that neighbour is the destination, short circuit
			if currentNeighbour == b:
				reachedDestination = true
				
			if currentNeighbour and not currentNeighbour.decorator and not blackList.has(currentNeighbour.position):
				distances[compass] = (b.position - currentNeighbour.position).length()
		
		# if we have no posible ways to move, chuck an error and return
		if distances.size() == 0:
			print("can not find a path from a to b", a.position, b.position)
			return
		
		# otherwise get the direction with the shortest vector and move to it
		var shortest = distances.keys()[0]
		for direction in distances:
			if distances[direction] < distances[shortest]:
				shortest = direction
		
		# move to the next cube
		currentCube = currentCube.neighbours[shortest]

		# add the cube to the path
		notionalPath.append(currentCube.position)
		
		# blacklist the cube so we don't move back to it
		blackList.append(currentCube.position)

		# if we have reached our destination, break
		if currentCube == b:
			reachedDestination = true

	# now we have our path, we can spawn the road
	for position in notionalPath:
		region.getCubeAtPosition(position).spawnDecorator("Road")
		region.getCubeAtPosition(position).decorator.spawnRoad()
		
		
