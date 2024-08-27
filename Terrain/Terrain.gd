@tool
extends MeshInstance3D

var TerrainVertexScn = preload("res://Terrain/TerrainVertex.tscn")
var TerrainSquareScn = preload("res://Terrain/TerrainSquare.tscn")

@export var width = 20
@export var length = 20
# the amount of increase for vert heights
@export var heightStep = 0.5

# where we are going to save the serialized terrain_data array
var terrain_data_file_path: String = "user://terrain_data.dat"
var terrain_squares_file_path: String = "user://terrain_squares.dat"

# a dictionary where each key is a Vector2 and each value is a float (the Y position).
# this is used to generate our terrain mesh
var terrain_data: Dictionary

# a dictionary of TerrainSquareTempates keyed by V2 locations
var terrain_squares: Dictionary

# a function to generate terrain data
func generate_terrain_data() -> Dictionary:
	var terrain_data: Dictionary = {}

	for x in range(self.width):
		for z in range(self.length):
			var position = Vector2(x, z)
			var height = 0
			terrain_data[position] = height
			# also allow for the middle vertices
			terrain_data[position + Vector2(0.5, 0.5)] = height
			# create a terrain square resource at this grid location
			var terrain_square = TerrainSquareTemplate.new()

			# Set the properties of the instance
			terrain_square.x = x
			terrain_square.z = z
			
			# load it into the grid
			terrain_squares[position] = terrain_square
	
	serializeTerrainData(terrain_data)
	
	# serialize the terrain_squares to a file
	var terrain_squares_file = FileAccess.open(terrain_squares_file_path, FileAccess.WRITE)
	if terrain_squares_file:
		terrain_squares_file.store_var(terrain_squares)
		terrain_squares_file.close()
	else:
		print("Error saving terrain_squares_file - file is null")
		
	return terrain_data

# save the terrain_data to a file
func serializeTerrainData(terrain_data):
	# serialize the terrain_data to a file
	var terrain_data_file = FileAccess.open(terrain_data_file_path, FileAccess.WRITE)
	if terrain_data_file:
		terrain_data_file.store_var(terrain_data)
		terrain_data_file.close()
	else:
		print("Error saving terrain_data_file - file is null")

# Called when the node enters the scene tree for the first time.
func _ready():
	gen_mesh()
	
func gen_mesh():
	# if we have a serialized file, load it
	if FileAccess.file_exists(terrain_data_file_path):
		var file = FileAccess.open(terrain_data_file_path, FileAccess.READ)
		self.terrain_data = file.get_var()
		file.close()
	else: 
		self.terrain_data = generate_terrain_data()
	
	# clear all the TerrainVertexes and TerrainSquares
	for child in $TerrainVertexes.get_children():
		child.queue_free()
	for child in $TerrainSquares.get_children():
		child.queue_free()

	var surface_tool = SurfaceTool.new()
	surface_tool.begin(Mesh.PRIMITIVE_TRIANGLES)
	surface_tool.set_smooth_group(-1)

	# Add vertices - our vertices are arranged in a grid, with a each grid square containing a fifth
	# vertice in the middle. This gives us four tris instead of two, so when we terraform and create
	# hills, the face is able to bend more flexibly
	var vertices = []
	var y = 0
	# first, just create the grid
	for x in range(self.width):
		for z in range(self.length):
			var position = Vector2(x, z)
			var vertex = Vector3(x, self.terrain_data[position], z)
			vertices.append(vertex)
			surface_tool.add_vertex(vertex)
			addTerrainVertex(position, self.terrain_data[position])
			addTerrainSquare(position, self.terrain_data[position])
	
	# now, add the middle vertices
	var middleVertices = []
	for x in range(self.width - 1):
		for z in range(self.length - 1):
			var position = Vector2(x + 0.5, z + 0.5)
			var vertex = Vector3(x + 0.5, self.terrain_data[position], z + 0.5)
			middleVertices.append(vertex)
			surface_tool.add_vertex(vertex)
	
	# Generate indices to create triangles between each of the grid verts and the middle verts
	for x in range(self.width - 1):
		for z in range(self.length - 1):
			var top_left = x + z * self.width
			var top_right = (x + 1) + z * self.width
			var middle = vertices.size() + x + z * (self.width - 1)
			var bottom_left = x + (z + 1) * self.width
			var bottom_right = (x + 1) + (z + 1) * self.width

			# top left triangle
			surface_tool.add_index(top_left)
			surface_tool.add_index(middle)
			surface_tool.add_index(top_right)

			# top right triangle
			surface_tool.add_index(top_right)
			surface_tool.add_index(middle)
			surface_tool.add_index(bottom_right)

			# bottom right triangle
			surface_tool.add_index(bottom_right)
			surface_tool.add_index(middle)
			surface_tool.add_index(bottom_left)

			# bottom left triangle
			surface_tool.add_index(bottom_left)
			surface_tool.add_index(middle)
			surface_tool.add_index(top_left)
			
	# Calculate and set normals
	surface_tool.generate_normals()

	# Calculate and set tangents
	surface_tool.generate_tangents()

	mesh = surface_tool.commit()

	# save the mesh as a resource
	ResourceSaver.save(mesh, "res://Terrain/terrain_mesh.tres", ResourceSaver.FLAG_COMPRESS)

# add a vertex scene that the user is able to click for actions
func addTerrainVertex(pos:Vector2, height:float):
	# instantiate the child scene
	var sphere = TerrainVertexScn.instantiate()
	# tell it which vertex it refers to
	sphere.referencePosition = pos
	# set its actual position
	sphere.position = Vector3(pos.x, height, pos.y)
	# make it a child of this scene
	$TerrainVertexes.add_child(sphere)
	# connect the modifyVertex signal to our onModifyVertex func
	sphere.modifyVertex.connect(onModifyVertex)

# add a grid square that the user is able to click for actions
func addTerrainSquare(pos:Vector2, height:float):
	var square = TerrainSquareScn.instantiate()
	
	square.top_left = self.terrain_data[pos] if self.terrain_data.has(pos) else 0
	square.top_right = self.terrain_data[pos + Vector2(1, 0)] if self.terrain_data.has(pos + Vector2(1, 0)) else 0
	square.bottom_left = self.terrain_data[pos + Vector2(0, 1)] if self.terrain_data.has(pos + Vector2(0, 1)) else 0
	square.bottom_right = self.terrain_data[pos + Vector2(1, 1)] if self.terrain_data.has(pos + Vector2(1, 1)) else 0

	# set its actual position
	square.position = Vector3(pos.x, 0.01, pos.y)
	# make it a child of this scene
	$TerrainSquares.add_child(square)
	
	# run its internal gen_mesh func
	square.gen_mesh()


func onModifyVertex(vertex: Vector2, modify: float):
	print("Modifying vertex: ", vertex, " by: ", modify)

	# don't allow modifying middle verts
	if abs(vertex.x - round(vertex.x)) == 0.5 and abs(vertex.y - round(vertex.y)) == 0.5:
		return
	
	# if any of the surrounding verts are more than 1 step in the opposite direction, cancel the move
	if surroundingVertsTooSteep(vertex, modify):
		return
	
	# set the new height
	self.terrain_data[vertex] += modify
	
	# get all the middle verts that touch this vertex
	var middleVerts = getSurroundingMiddleVerts(vertex)

	# for each of those middle verts, check all of its surrounding non-middle verts:
	for middleVert in middleVerts:
		# if it doesn't exist in our terrain data, skip it
		if not self.terrain_data.has(middleVert):
			continue
		
		var top_left = Vector2(middleVert.x - 0.5, middleVert.y - 0.5)
		var top_right = Vector2(middleVert.x + 0.5, middleVert.y - 0.5)
		var bottom_left = Vector2(middleVert.x - 0.5, middleVert.y + 0.5)
		var bottom_right = Vector2(middleVert.x + 0.5, middleVert.y + 0.5)

		# if any of the diagonal verts are the same height, set the middle vert to that height
		if self.terrain_data.has(top_left) and self.terrain_data.has(bottom_right):
			if self.terrain_data[top_left] == self.terrain_data[bottom_right]:
				self.terrain_data[middleVert] = self.terrain_data[top_left]
				continue
		if self.terrain_data.has(top_right) and self.terrain_data.has(bottom_left):
			if self.terrain_data[top_right] == self.terrain_data[bottom_left]:
				self.terrain_data[middleVert] = self.terrain_data[top_right]
				continue
		
		# at this point, diagonals are not the same

		# if any of the horizontal or vertical verts are the same height, but the opposing
		# edge is not, set the middle vert to the average of the two
		if self.terrain_data.has(top_left) and self.terrain_data.has(top_right):
			if self.terrain_data[top_left] == self.terrain_data[top_right]:
				if self.terrain_data.has(bottom_left) and self.terrain_data.has(bottom_right):
					if self.terrain_data[bottom_left] == self.terrain_data[bottom_right] and self.terrain_data[bottom_left] != self.terrain_data[top_left]:
						self.terrain_data[middleVert] = (self.terrain_data[top_left] + self.terrain_data[bottom_left]) / 2
						continue
		if self.terrain_data.has(bottom_left) and self.terrain_data.has(bottom_right):
			if self.terrain_data[bottom_left] == self.terrain_data[bottom_right]:
				if self.terrain_data.has(top_left) and self.terrain_data.has(top_right):
					if self.terrain_data[top_left] == self.terrain_data[top_right] and self.terrain_data[top_left] != self.terrain_data[bottom_left]:
						self.terrain_data[middleVert] = (self.terrain_data[top_left] + self.terrain_data[bottom_left]) / 2
						continue
		if self.terrain_data.has(top_left) and self.terrain_data.has(bottom_left):
			if self.terrain_data[top_left] == self.terrain_data[bottom_left]:
				if self.terrain_data.has(top_right) and self.terrain_data.has(bottom_right):
					if self.terrain_data[top_right] == self.terrain_data[bottom_right] and self.terrain_data[top_right] != self.terrain_data[top_left]:
						self.terrain_data[middleVert] = (self.terrain_data[top_left] + self.terrain_data[top_right]) / 2
						continue
		if self.terrain_data.has(top_right) and self.terrain_data.has(bottom_right):
			if self.terrain_data[top_right] == self.terrain_data[bottom_right]:
				if self.terrain_data.has(top_left) and self.terrain_data.has(bottom_left):
					if self.terrain_data[top_left] == self.terrain_data[bottom_left] and self.terrain_data[top_left] != self.terrain_data[top_right]:
						self.terrain_data[middleVert] = (self.terrain_data[top_left] + self.terrain_data[top_right]) / 2
						continue
						
	serializeTerrainData(self.terrain_data)
	gen_mesh()
	
func surroundingVertsTooSteep(vertex: Vector2, modify: float):
	for x in range(-1, 2):
		for z in range(-1, 2):
			var pos = Vector2(vertex.x + x, vertex.y + z)
			if self.terrain_data.has(pos):
				# if moving up
				if modify > 0:
					if self.terrain_data[pos] < self.terrain_data[vertex]:
						return true
				# if moving down
				if modify < 0:
					if self.terrain_data[pos] > self.terrain_data[vertex]:
						return true
	return false



# given a vert position, get all the connecting middle vert positions
# note this works when converting from middle to edge and edge to middle, it's the same calculation.
func getSurroundingMiddleVerts(pos: Vector2):
	return [
		Vector2(pos.x -0.5, pos.y -0.5),
		Vector2(pos.x +0.5, pos.y -0.5),
		Vector2(pos.x -0.5, pos.y +0.5),
		Vector2(pos.x +0.5, pos.y +0.5)
	]

### debug - allow for debug rendering (press p to cycle through)
func _init():
	RenderingServer.set_debug_generate_wireframes(true)

func _input(event):
	if event is InputEventKey and Input.is_key_pressed(KEY_P):
		var vp = get_viewport()
		vp.debug_draw = (vp.debug_draw + 1 ) % 5
