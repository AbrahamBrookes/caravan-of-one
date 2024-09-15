extends Decorator
class_name Farmhouse

# the Farmhouse is a decorator that provides a farming family to the surrounding countryside.
# A Farmhouse has linked plots, and every day a labourer will sally forth from the farmhouse
# and tend one plot. Depending on the skill of the farmer and the amount of times a plot is
# tended, a different amount of produce will be borne from the plot at harves time. Different
# plot types have different growing lengths and different harvest schedules.

# a list of linked plots
@export var plots:Array[FarmPlot] = []

# a list of labourers available in this farmhouse
var labourers = []

# Called when the node enters the scene tree for the first time.
#func _ready():
#	if plots.size() == 0:
#		spawnPlots()

# A Farmhouse is always surrounded by plots
func spawnPlots():
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
		cube.spawnDecorator("FarmPlot")
		# add the marketplace to the plots array
		plots.append(cube.decorator as FarmPlot)
		#set this Farmhouse as the parent of the FarmPlot
		cube.decorator.farmhouse = self
