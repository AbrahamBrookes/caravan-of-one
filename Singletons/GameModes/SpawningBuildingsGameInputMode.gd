extends GameInputMode
class_name SpawningBuildingsGameInputMode

# which building are we spawning
var decorator_to_spawn: String

func click(cube : TerrainCube = null):
	# if we don't have a decorator to spawn we can't do anything
	if not decorator_to_spawn:
		return
	
	cube.spawnDecorator(decorator_to_spawn)
