extends Node
class_name GameInputMode

# In our game we have multiple different modes where interaction is different
# depending on the game mode at the time. For instance when we are spawning roads
# vs when we are controlling battle units. We use GameInputModes to route input
# through a class that handles input actions and fires off effects relevant to
# the game mode. This way we can avoid conditionals and write input handlers
# directly into sensibly siloed classes. The GameInputMode scene is an autoload
# singleton that provides a switch between game modes.

# Use ie GameInput.click() to click in the current input mode

# the game mode that we will route input to
var current_game_mode : GameInputMode

# when we boot up, default to basic game mode
func _ready():
	current_game_mode = $BasicGameInputMode

# passing a GameMode enum switches which child scene we will route actions to
func setGameMode(mode: int, data = null):
	match mode:
		GameModeEnum.BASE:
			current_game_mode = $BasicGameInputMode
		GameModeEnum.SPAWNING_BUILDINGS:
			current_game_mode = $SpawningBuildingsGameInputMode
			current_game_mode.decorator_to_spawn = data
		GameModeEnum.SPAWNING_ROADS:
			current_game_mode = $SpawningRoadsGameInputMode
		

func click(data = null):
	if not current_game_mode:
		push_error("GameInputMode not set")
		return
	if not current_game_mode.has_method('click'):
		push_error("click not implemented on the current game mode")
		return
	current_game_mode.click(data)

func rightClick():
	if not current_game_mode:
		push_error("GameInputMode not set")
		return
	if not current_game_mode.has_method('rightClick'):
		push_error("rightClick not implemented on the current game mode")
		return
	current_game_mode.rightClick()

func mouseEnter(data = null):
	if not current_game_mode:
		push_error("GameInputMode not set")
		return
	if not current_game_mode.has_method('mouseEnter'):
		push_error("mouseEnter not implemented on the current game mode")
		return
	current_game_mode.mouseEnter(data)

func mouseLeave(data = null):
	if not current_game_mode:
		push_error("GameInputMode not set")
		return
	if not current_game_mode.has_method('mouseLeave'):
		push_error("mouseLeave not implemented on the current game mode")
		return
	current_game_mode.mouseLeave(data)
