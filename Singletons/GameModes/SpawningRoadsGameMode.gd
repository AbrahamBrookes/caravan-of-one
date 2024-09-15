extends GameInputMode
class_name SpawningRoadsGameInputMode

# whenever the user clicks we want to place a road point and then spawn roads in
# a path to the next road point. The user clicks once, this creates the 'from'
# point, then they click again to place the 'to' point, and as they hover, we
# notionally spawn in road tiles connecting the two points in a straight line.

# these road points are cubes in the region
var road_point_1 : TerrainCube
# road_point_2 will be updated continually on hover
var road_point_2 : TerrainCube

# when we are placing a road we are going in one compass direction at a time. In
# order to select decorators, we'll have RoadModes which are dictionaries that
# we will switch to and then blindly select from
var RoadModes : Dictionary = {
	"S2N": {
		"start": "n",
		"middle": "n_s",
		"end": "s"
	},
	"N2S": {
		"start": "s",
		"middle": "n_s",
		"end": "n"
	},
	"E2W": {
		"start": "w",
		"middle": "e_w",
		"end": "e"
	},
	"W2E": {
		"start": "e",
		"middle": "e_w",
		"end": "w"
	}
}

# as we hover we'll be spawning notional decorators on cubes along the path. This 
# array stores those cubes, so we can despawn them whenever a new cube is hovered
var notional_cubes : Array[TerrainCube] = []

func click(cube : TerrainCube = null):
	if not road_point_1:
		road_point_1 = cube
		return
	# if we are clicking and we already have a road_point_1 then we are confirming
	confirmRoad()

func mouseEnter(cube : TerrainCube = null):
	if road_point_1:
		road_point_2 = cube
		hoverPath()

func hoverPath():
	# despawn all notional cubes
	for cube in notional_cubes:
		cube.destoryDecorator()

	# figure out which direction we are going
	var vertical = road_point_1.position.z - road_point_2.position.z
	var horizontal = road_point_1.position.x - road_point_2.position.x

	var mode = null

	# if the abs of the vertical is greater than the abs of the horizontal
	# then we are going in a vertical direction
	if abs(vertical) > abs(horizontal):
		if vertical > 0:
			mode = RoadModes["S2N"]
			# fudge road_point_2 to be the cube that is actually in the direction we are going
			road_point_2 = road_point_1.region.getCubeAtPosition(road_point_1.position + Vector3(0, 0, road_point_2.position.z - road_point_1.position.z))
		else:
			mode = RoadModes["N2S"]
			# fudge road_point_2 to be the cube that is actually in the direction we are going
			road_point_2 = road_point_1.region.getCubeAtPosition(road_point_1.position + Vector3(0, 0, road_point_2.position.z - road_point_1.position.z))
	else:
		if horizontal > 0:
			mode = RoadModes["E2W"]
			# fudge road_point_2 to be the cube that is actually in the direction we are going
			road_point_2 = road_point_1.region.getCubeAtPosition(road_point_1.position + Vector3(road_point_2.position.x - road_point_1.position.x, 0, 0))
		else:
			mode = RoadModes["W2E"]
			# fudge road_point_2 to be the cube that is actually in the direction we are going
			road_point_2 = road_point_1.region.getCubeAtPosition(road_point_1.position + Vector3(road_point_2.position.x - road_point_1.position.x, 0, 0))
	
	# we have the mode, now we can spawn in the notional cubes
	# we can do this by finding the vector between the two points and then
	# spawning in road tiles along that vector
	var vector = road_point_2.position - road_point_1.position
	var current_point = road_point_1.position
	while current_point != road_point_2.position:

		var cube = road_point_1.region.getCubeAtPosition(current_point)
		if cube:
			cube.spawnDecorator("Road")
			cube.decorator.spawnRoad()
			notional_cubes.append(cube)
			
		current_point += vector.normalized()

func confirmRoad():
	# simply clear out the road points and notional cubes since they are already spawned
	road_point_1 = null
	road_point_2 = null
	notional_cubes = []
