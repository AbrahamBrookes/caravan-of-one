extends Decorator

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
func _ready():
	print('farmhouse ready')
