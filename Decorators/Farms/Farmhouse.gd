extends Node3D

# the Farmhouse is a decorator that provides a farming family to the surrounding countryside.
# A Farmhouse has linked plots, and every day a labourer will sally forth from the farmhouse
# and tend one plot. Depending on the skill of the farmer and the amount of times a plot is
# tended, a different amount of produce will be borne from the plot at harves time. Different
# plot types have different growing lengths and different harvest schedules.

# a list of linked plots
@export var plots:Array[FarmPlot] = []

# a list of containers that are on site
@export var containers:Array[ItemContainer] = []

# a list of labourers available in this farmhouse
var labourers = []

# a link to the TerrainSquare on which this decorator sits
var square:TerrainSquare

# Called when the node enters the scene tree for the first time.
func _ready():
	# create 5 labourers in our house
	labourers = [
		Farmer.new(),
		Farmer.new(),
		Farmer.new(),
		Farmer.new(),
		Farmer.new(),
	]


# Called when the sun rises
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
