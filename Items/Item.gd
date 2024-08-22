extends Resource
class_name Item

# the item class is a base resource used to define items in our game. When you want to create a new
# item, right click in the file explorer and go Create New > Resource, then search for "Item". You
# can then edit the below values and save a .tres file. In anything that uses that item, create a
# new @export variable of type Item and assign your .tres file.

@export var name: String
@export var weight: float
@export var size: float
@export var base_price: float
@export var description: String
