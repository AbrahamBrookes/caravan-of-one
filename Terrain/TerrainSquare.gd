class_name TerrainSquare
extends MeshInstance3D

# the heights of the surrounding verts
var top_left
var top_right
var bottom_left
var bottom_right

# the mesh for this object is similar to the mesh for the terrain object, but it wraps to a single grid square
# and we will only ever show the outline so we don't need the middle vert fanciness here
func gen_mesh():
	var surface_tool = SurfaceTool.new()
	surface_tool.begin(Mesh.PRIMITIVE_TRIANGLES)
	surface_tool.set_smooth_group(-1)

	# add the vertices
	surface_tool.add_vertex(Vector3(0, top_left, 0))
	surface_tool.add_vertex(Vector3(1, top_right, 0))
	surface_tool.add_vertex(Vector3(0, bottom_left, 1))
	surface_tool.add_vertex(Vector3(1, bottom_right, 1))
	
	# add the faces using indices
	surface_tool.add_index(0)
	surface_tool.add_index(1)
	surface_tool.add_index(3)

	surface_tool.add_index(0)
	surface_tool.add_index(3)
	surface_tool.add_index(2)

	# Calculate and set normals
	surface_tool.generate_normals()

	# Calculate and set tangents
	surface_tool.generate_tangents()

	$MeshInstance3D.mesh = surface_tool.commit()
	
	# also commit the shape to the collision shape
	var shape = ConvexPolygonShape3D.new()
	$Area3D/CollisionShape3D.shape = $MeshInstance3D.mesh.create_convex_shape()


func on_mouse_entered():
	# show the MeshInstance3D child
	$MeshInstance3D.visible = true

func on_mouse_exited():
	# hide the MeshInstance3D child
	$MeshInstance3D.visible = false

#func on_click():
	# show a UI dropdown for creating a decorator


