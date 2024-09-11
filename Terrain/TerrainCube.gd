extends MeshInstance3D
class_name TerrainCube

# a reference to the parent grid into which this cube is spawned
var region : TerrainCubeRegion

# a reference to the decorator on this cube
var decorator : Decorator

# a list of Decorator types that may be spawned on this cube
var possibleDecorators : Dictionary = {
	"TownMarker": preload("res://Decorators/Towns/TownMarker/TownMarker.tscn"),
	"Marketplace": preload("res://Decorators/Towns/Marketplace/Marketplace.tscn"),
	"Blacksmith": preload("res://Decorators/Towns/Blacksmith/Blacksmith.tscn"),
	"Farmhouse": preload("res://Decorators/Farms/Farmhouse.tscn"),
	"Road": preload("res://Decorators/Farms/Farmhouse.tscn")
}

# mouse signals
signal mouse_entered
signal mouse_exited
signal mouse_clicked

# when we are mouse entered, emit the signal up out of the scene
func on_mouse_entered():
	mouse_entered.emit(self)

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
	else:
		print(name + " not found in list of spawnable decorators")

func handleRoadSpawnClick():
	spawnDecorator("Road")
