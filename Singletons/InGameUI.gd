extends Control

# an enum for game mode, that we can check to figure out what to do when clicking a cube
enum GameMode {
	BASE,
	SPAWNING
}

# the current game mode
var current_game_mode : GameMode = GameMode.BASE

# the name of the decorator we are currently spawning
var decorator_to_spawn : String = ""

func showElement(node : String, data : Dictionary = {}):
	# show the child node using the string as the name
	var child = get_node(node)
	if child != null:
		child.show()
		# if the node has an init method then it is expecting some data
		if child.has_method("init"):
			child.init(data)
	else:
		print("Child node not found: ", node)

func hideElement(node : String):
	# hide the child node using the string as the name
	var child = get_node(node)
	if child != null:
		child.hide()
	else:
		print("Child node not found: ", node)

func setSpawning(decorator: String):
	current_game_mode = GameMode.SPAWNING
	decorator_to_spawn = decorator

