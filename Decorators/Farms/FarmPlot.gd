extends Decorator
class_name FarmPlot

# the FarmPlot class is attached to a Farmhouse and it produces a set amount of some produce after
# some amount of time. The amount of time changes depending on the climate, the season, and the
# stats of the connected Farmhouse.

# a reference to the Farmhouse that this FarmPlot is attached to
var farmhouse : Farmhouse = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
