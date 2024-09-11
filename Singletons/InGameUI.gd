extends Control

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
	GameInput.setGameMode(GameModeEnum.SPAWNING_BUILDINGS, decorator)

