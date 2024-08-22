@tool
extends Item
class_name ItemContainer

# the ItemContainer class is a resource template that you can use to create your own containers. A
# container has a capacity to hold a set amount of cubes. It is itself an item, so it can be bought,
# sold and transported. In order to create a new container type, right click in the file explorer,
# select Create New > Resource and search for ItemContainer. You can then set the values of both the
# base item class and the values here below

@export var capacity:float

# Use custom getter and setter to enforce capacity
@export var items: Array[ItemStack] :
	get:
		return items
	set(value):
		# sum the size of all items in the incoming array
		var total_size:int = 0
		for item_stack in value:
			total_size += item_stack.size
		# if it is less than capacity, allow it
		if total_size <= capacity:
			items = value
		else:
			push_error("Cannot set items - exceeds container capacity.")

## computed getters
# how much capacity is currently being used
@export var used_capacity:int :
	get:
		var used:int = 0
		for item_stack in items:
			used += item_stack.size
		return used
	set(value):
		pass

# how much space we have left
@export var remaining_capacity:int :
	get:
		return capacity - used_capacity
	set(value):
		pass

## end computed getters

# given an Item, check if this container has room for it
func can_fit(item:ItemStack):
	return capacity - item.size > 0

# add an item to this container, if there is room
func deposit(item:ItemStack):
	if can_fit(item):
		items.append(item)

# remove an item from this container, returning it to context
#func take(item:Item):
	
