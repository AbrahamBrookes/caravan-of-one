extends Decorator
class_name TownMarker

# the TownMarker is the center of any given town. It is a decorator because it consumes a single cube
# in the terrain. Players can click on the town marker to get info about the town. A TownMarker may
# also consume the 8 surrounding tiles in order to define a central marketplace, which all Towns have.

# our lists of linked plots
var marketplaces:Array[Marketplace] = []
var roads:Array[Road] = []

# on start, we spawn the marketplaces
#func _ready():
#	if marketplaces.size() == 0:
#		spawnMarketplaces()

# A Town Marker is always surrounded by 8 marketplace tiles
func spawnMarketplaces():
	# get the region
	var region = terrainCube.region
	# an array of location offsets to loop through
	var offsets = [
		Vector3(-1, 0, -1),
		Vector3(0,  0, -1),
		Vector3(1,  0, -1),
		Vector3(-1, 0, 0),
		Vector3(1,  0, 0),
		Vector3(-1, 0, 1),
		Vector3(0,  0, 1),
		Vector3(1,  0, 1)
	]
	# loop through the offsets and spawn a marketplace at each location
	for offset in offsets:
		var cube = region.getCubeAtPosition(terrainCube.position + offset)
		# add the marketplace to the terrainCube
		cube.spawnDecorator("Marketplace")
		# add the marketplace to the marketplaces array
		marketplaces.append(cube.decorator as Marketplace)

# find and higlight any build locations that we might use next
func highlight_build_locations():
	# access the parent terrainCube and then the TerrainCubeRegion to query the surrounding tiles
	var region = terrainCube.terrainCubeRegion


