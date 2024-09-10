extends Node3D
class_name TerrainCubeRegion

# A TerrainCubeRegion is a given region of the terrain. This has a limited size so that we can stream
# and despawn each region as we need to, in order to keep performance high and be able to have a large
# world to play in.

# our grid dimensions
@export var depth : int = 100
@export var width : int = 100
@export var height : int = 100

# our terrain cube scenes that we will instantiate
var cube = load("res://Terrain/TerrainCube.tscn")

# the location of the serialized file we use for saving/loading this region
var terrain_data_file_path : String = "user://terrainData.dat"

# our deserialized terrain data to use when spawning the terrain
var terrain_data : Dictionary

# our list of hydrated cube scenes, also a dictiopnary keyed by v3
var cubes : Dictionary

# Called when the node enters the scene tree for the first time.
func _ready():
	# if we have a serialized terrain data file, load it
	#if FileAccess.file_exists(terrain_data_file_path):
	#	var file = FileAccess.open(terrain_data_file_path, FileAccess.READ)
	#	self.terrain_data = file.get_var()
	#	file.close()
	#	print("loaded terrain data from file")
	#else: 
	self.terrain_data = generate_terrain_data()

	# now that we have loaded the data, hydrate it
	hydrate()

# a function to generate terrain data which will then be used for hydrating the scene
func generate_terrain_data():
	var generatedTerrain: Dictionary = {}
	
	for x in width:
		for z in depth:
			# let's just generate a single layer at the 25 location for now
			var position = Vector3(x, 0, z)
			# we are not instantiating scenes at this point, this is just a raw data layer
			# save this to the dictionary
			generatedTerrain[position] = {
				"position": position,
			}
	
	return generatedTerrain


# save the terrain_data to a file
func serializeTerrainData(terrainData):
	# serialize the terrain_data to a file
	var terrain_data_file = FileAccess.open(terrain_data_file_path, FileAccess.WRITE)
	if terrain_data_file:
		terrain_data_file.store_var(terrainData)
		terrain_data_file.close()
	else:
		print("Error saving terrain_data_file - file is null")

# using self.terrain_data, spawn the relevant scenes
func hydrate():
	for x in width:
		for z in depth:
			for y in height:
				var position = Vector3(x, y, z)
				# if the cur position exists in terrain_data, load the cube
				if terrain_data.has(position):
					# instantiate a cube
					var inst = cube.instantiate()
					# anchor it
					add_child(inst)
					# hydrate it
					if(inst.has_method("hydrate")):
						inst.hydrate(terrain_data[position], self)
					# push it into the cubes dictionary
					cubes[position] = inst

# a method to dehydrate the terrain and get data for serialization
func dehydrate():
	var data : Dictionary = {}
	# call dehydrate on each of our cubes
	for location in cubes:
		data[location] = cubes[location].dehydrate()
	
	return data
	
func getCubeAtPosition(position: Vector3):
	if cubes.has(position):
		return cubes[position]
	else:
		push_error("attempted to get a cube but not found")
