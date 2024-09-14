extends MeshInstance3D
class_name TerrainCube

# a reference to the parent grid into which this cube is spawned
var region : TerrainCubeRegion

# a dictionary with compass directions and neighboring cubes
var neighbours : Dictionary = {
	"n": null,
	"s": null,
	"e": null,
	"w": null,
}

# a reference to the decorator on this cube
var decorator : Decorator

# the name of the decorator on this cube
var decoratorName : String

# a list of Decorator types that may be spawned on this cube
var possibleDecorators : Dictionary = {
	"TownMarker": preload("res://Decorators/Towns/TownMarker/TownMarker.tscn"),
	"Marketplace": preload("res://Decorators/Towns/Marketplace/Marketplace.tscn"),
	"Blacksmith": preload("res://Decorators/Towns/Blacksmith/Blacksmith.tscn"),
	"Farmhouse": preload("res://Decorators/Farms/Farmhouse.tscn"),
	"Road": preload("res://Decorators/Roads/Road.tscn")
}

# mouse signals
signal mouse_entered
signal mouse_exited
signal mouse_clicked

# when we are mouse entered, emit the signal up out of the scene
func on_mouse_entered():
	GameInput.mouseEnter(self)

# when we are mouse exited, emit the signal up out of the scene
func on_mouse_exited():
	mouse_exited.emit()

# an incoming click event - delegated down to the Decorator if exists
func click(camera, event, position, normal, shape_idx):
	if event is InputEventMouseButton and event.pressed:
		GameInput.click(self)

# a method for deserializing yourself based on passed hydration data
func hydrate(data, terrain : TerrainCubeRegion):
	position = data.position
	region = terrain

# a method for dehydrating yourself to pas up for serialization
func dehydrate():
	var data : Dictionary = {
		"position": position
	}
	
	# if we have a decorator, also dehydrate it
	if decorator:
		data["decorator"] = decorator.dehydrate()
	
	return data

func spawnDecorator(name : String):
	# only do this if we don't already have a decorator
	if decorator:
		print("already have a decorator")
		return
	# find the decorator in our dictionary
	if possibleDecorators.has(name):
		decorator = possibleDecorators[name].instantiate()
		decorator.terrainCube = self
		add_child(decorator)
		decoratorName = name
	else:
		print(name + " not found in list of spawnable decorators")

func destoryDecorator():
	if not decorator:
		return
	decorator.queue_free()
	decorator = null

func cacheNeighbours():
	neighbours["n"] = region.getCubeAtPosition(Vector3(position.x, position.y, position.z - 1))
	neighbours["s"] = region.getCubeAtPosition(Vector3(position.x, position.y, position.z + 1))
	neighbours["e"] = region.getCubeAtPosition(Vector3(position.x + 1, position.y, position.z))
	neighbours["w"] = region.getCubeAtPosition(Vector3(position.x - 1, position.y, position.z))

func handleRoadSpawnClick():
	spawnDecorator("Road")

func getNeighbors():
	var neighbors = []
	var x = position.x
	var y = position.y
	var z = position.z
	for i in range(-1, 2):
		for j in range(-1, 2):
			for k in range(-1, 2):
				if i == 0 and j == 0 and k == 0:
					continue
				var neighbor = region.getCubeAtPosition(Vector3(x + i, y + j, z + k))
				if neighbor:
					neighbors.append(neighbor)
	return neighbors
