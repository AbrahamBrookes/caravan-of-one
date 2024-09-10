extends Node3D

# the position of this vertex in the reference array
var referencePosition: Vector2

# define our modifyVertex signal
# pass the position of the vertex in our reference array, and how to modify it on the y
signal modifyVertex(vertex:Vector2, addY:float)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func on_mouse_entered():
	# show the MeshInstance3D child
	$MeshInstance3D.visible = true


func on_mouse_exited():
	# hide the MeshInstance3D child
	$MeshInstance3D.visible = false


func on_click(camera, event, position, normal, shape_idx):
	# only if this is a mouse up
	if event is InputEventMouseButton and event.pressed == false:
		return

	# if this is a left mouse button click
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		# emit a signal to the parent node
		modifyVertex.emit(referencePosition, 1)
	
	# if this is a right mouse button click
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT:
		# emit a signal to the parent node
		modifyVertex.emit(referencePosition, -1)
