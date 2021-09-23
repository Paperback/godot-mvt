extends Node

func _init():
	Log.verbose("Mesh: initialized")

static func box(size):
	var outside = PoolVector3Array()
#	outside.append(Vector3(-size.x, 0, -size.z) * 0.5)
#	outside.append(Vector3(-size.x, 0, size.z) * 0.5)
#	outside.append(Vector3(size.x, 0, size.z) * 0.5)
#	outside.append(Vector3(size.x, 0, -size.z) * 0.5)
	
	outside.append(Vector3(0, 0, 0))
	outside.append(Vector3(0, 0, size.z))
	outside.append(Vector3(size.x, 0, size.z))
	outside.append(Vector3(size.x, 0, 0))
	
	var arrays = []
	arrays.resize(ArrayMesh.ARRAY_MAX)
	arrays[ArrayMesh.ARRAY_VERTEX] = outside
	var mesh = ArrayMesh.new()
	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_LINE_LOOP, arrays)
	return mesh
	
static func squareST(size):
	var st = SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_LINE_LOOP)
	st.add_color(Color(1, 0, 0))
	st.add_uv(Vector2(0, 0))
	st.add_vertex(Vector3(0, 0, 0))
	
	st.add_color(Color(1, 0, 0))
	st.add_uv(Vector2(0, size.z))
	st.add_vertex(Vector3(0, 0, size.z))
	
	st.add_color(Color(1, 0, 0))
	st.add_uv(Vector2(size.x, size.z))
	st.add_vertex(Vector3(size.x, 0, size.z))
	
	st.add_color(Color(1, 0, 0))
	st.add_uv(Vector2(size.x, 0))
	st.add_vertex(Vector3(size.x, 0, 0))
	
	# st.set_material(preload("res://scenes/main/test.tres"))
	return st.commit()

static func square(size):
	var points = PoolVector3Array()
	var index = PoolIntArray()
	var colors = PoolColorArray()
	
	points.append(Vector3(0, 0, 0))
	colors.append(Color(255, 0, 0))
	points.append(Vector3(0, 0, size.z))
	colors.append(Color(255, 0, 0))
	points.append(Vector3(size.x, 0, size.z))
	colors.append(Color(255, 0, 0))
	points.append(Vector3(size.x, 0, 0))
	colors.append(Color(255, 0, 0))
	
	index.append(0)
	index.append(1)
	index.append(1)
	index.append(2)
	index.append(2)
	index.append(3)
	index.append(3)
	index.append(0)
	
#	index.append(0)
#	index.append(2)
#
#	index.append(1)
#	index.append(3)
	
	#points.append(Vector2(0, 0))
	#points.append(Vector2(size.x, size.z))
	
	var arrays = []
	arrays.resize(ArrayMesh.ARRAY_MAX)
	arrays[ArrayMesh.ARRAY_VERTEX] = points
	arrays[ArrayMesh.ARRAY_COLOR] = colors
	arrays[ArrayMesh.ARRAY_INDEX] = index
	var mesh = ArrayMesh.new()
	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_LINES, arrays)
	# mesh.surface_set_material(0, preload("res://scenes/main/test.tres"))
	
	return mesh

static func box2D(size):
	var outside = PoolVector3Array()
#	outside.append(Vector3(-size.x, 0, -size.z) * 0.5)
#	outside.append(Vector3(-size.x, 0, size.z) * 0.5)
#	outside.append(Vector3(size.x, 0, size.z) * 0.5)
#	outside.append(Vector3(size.x, 0, -size.z) * 0.5)
	
	outside.append(Vector3(0, 0, 0))
	outside.append(Vector3(0, 0, size.y))
	outside.append(Vector3(size.x, 0, size.y))
	outside.append(Vector3(size.x, 0, 0))
	
	var arrays = []
	arrays.resize(ArrayMesh.ARRAY_MAX)
	arrays[ArrayMesh.ARRAY_VERTEX] = outside
	var mesh = ArrayMesh.new()
	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_LINE_LOOP, arrays)
	return mesh

static func grid(size):
	var points = PoolVector3Array()
	var index = PoolIntArray()
	var colors = PoolColorArray()
	
	var current_index = 0
	for x in size.x:
		for y in size.y:
			var p := Vector3(x, 0, y)
			points.append(p)
			colors.append(Color(255, 0, 0))
			points.append(p + Vector3(0, 0, size.z))
			colors.append(Color(255, 0, 0))
			points.append(p + Vector3(size.x, 0, size.z))
			colors.append(Color(255, 0, 0))
			points.append(p + Vector3(size.x, 0, 0))
			colors.append(Color(255, 0, 0))
			index.append(0 + current_index)
			index.append(1 + current_index)
			index.append(1 + current_index)
			index.append(2 + current_index)
			index.append(2 + current_index)
			index.append(3 + current_index)
			index.append(3 + current_index)
			index.append(0 + current_index)
			current_index += 4
	
	var arrays = []
	arrays.resize(ArrayMesh.ARRAY_MAX)
	arrays[ArrayMesh.ARRAY_VERTEX] = points
	arrays[ArrayMesh.ARRAY_COLOR] = colors
	arrays[ArrayMesh.ARRAY_INDEX] = index
	var mesh = ArrayMesh.new()
	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
	# mesh.surface_set_material(0, preload("res://scenes/main/test.tres"))
	
	return mesh

static func arrow(dir):
	var points = PoolVector3Array()
	var arrays = []
	points.append(Vector3(0, 0, 0))
	points.append(dir)
	
	points.append(dir)
	points.append(dir - dir * (0.5 * Vector3.UP - Vector3.BACK))

	points.append(dir)
	points.append(dir - dir * (0.5 * Vector3.UP - Vector3.FORWARD))
	
	points.append(dir)
	points.append(dir - dir * (0.5 * Vector3.UP - Vector3.LEFT))

	points.append(dir)
	points.append(dir - dir * (0.5 * Vector3.UP - Vector3.RIGHT))
	
	arrays.resize(ArrayMesh.ARRAY_MAX)
	arrays[ArrayMesh.ARRAY_VERTEX] = points
	var mesh = ArrayMesh.new()
	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_LINES, arrays)
	return mesh

static func build(mesh):
	var mi = MeshInstance.new()
	mi.mesh = mesh
	return mi

#static func polygon(data: PoolVector2Array) -> MeshInstance:
#	var points = PoolVector3Array()
#	var arrays = []
#	arrays.resize(ArrayMesh.ARRAY_MAX)
#	arrays[ArrayMesh.ARRAY_VERTEX] = points
#	var mesh = ArrayMesh.new()
#	#Geometry.polygon
#	mesh.add_surface_from_arrays(Mesh.PRIM, arrays)
#	return build(mesh)
