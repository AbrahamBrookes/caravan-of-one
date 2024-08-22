extends Item
class_name ItemContainer

# the ItemContainer class is a resource template that you can use to create your own containers. A
# container has a capacity to hold a set amount of cubes. It is itself an item, so it can be bought,
# sold and transported. In order to create a new container type, right click in the file explorer,
# select Create New > Resource and search for ItemContainer. You can then set the values of both the
# base item class and the values here below

@export var capacity:float
