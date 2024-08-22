@tool
extends Resource
class_name ItemStack

# an ItemStack is a stack of items. It appends a quantity and has some helpful functions that allow
# us to check things about the stack, like its total capacity and weight

@export var item: Item
@export var quantity: int

## computed getters
# the total storage capacity this stack takes up
@export var size:float :
	get:
		if item == null:
			return 0
		return item.size * quantity
	set(value):
		pass # read only

# the total weight of the item stack
@export var weight:float :
	get:
		if item == null:
			return 0
		return item.weight * quantity
	set(value):
		pass # read only

# the total value of the item stack
@export var value:float :
	get:
		if item == null:
			return 0
		return item.base_price * quantity
	set(value):
		pass # read only

## end computed getters
