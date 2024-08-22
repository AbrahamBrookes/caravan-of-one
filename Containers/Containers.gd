extends Node
class_name Containers

# the Containers scene type is simply a scene-level reference to all the containers in the parent
# scene. Use this as a sub-scene to give your own scene the capacity to store items.

# the list of all ItemContainers belonging to this scene
@export var containers:Array[ItemContainer] = []

# a helper function to get an ItemStack representing all items of a given type in all containers
func all(item:Item):
	var stack:ItemStack = ItemStack.new()
	stack.item = item
	stack.quantity = 0
	
	for container in containers:
		for item_stack in container.items:
			if item_stack.item == item:
				stack.quantity += item_stack.quantity
	
	return stack
