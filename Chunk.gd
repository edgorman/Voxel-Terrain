extends StaticBody
tool

const vertices = [
	Vector3(0, 0, 0), #0
	Vector3(1, 0, 0), #1
	Vector3(0, 1, 0), #2
	Vector3(1, 1, 0), #3
	Vector3(0, 0, 1), #4
	Vector3(1, 0, 1), #5
	Vector3(0, 1, 1), #6
	Vector3(1, 1, 1)  #7
]

const TOP = [2, 3, 7, 6]
const BOTTOM = [0, 4, 5, 1]
const LEFT = [6, 4, 0, 2]
const RIGHT = [3, 1, 5, 7]
const FRONT = [7, 5, 4, 6]
const BACK = [2, 0, 1, 3]

var blocks = []

var st = SurfaceTool.new()
var mesh = null
var mesh_instance = null

func _ready():
	update()

func update():
	# Unload mesh
	if mesh_instance != null:
		mesh_instance.call_deferred("queue_free")
		mesh_instance = null
	
	# Create new mesh
	mesh = Mesh.new()
	mesh_instance = MeshInstance.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	
	# Loop through blocks in chunk
	for x in Global.DIMENSION.x:
		for y in Global.DIMENSION.y:
			for z in Global.DIMENSION.z:
				create_block(x, y, z)
	
	# Set mesh normals and material
	st.generate_normals(false)
	st.set_material(mesh)
	st.commit(mesh)
	mesh_instance.set_mesh(mesh)
	
	add_child(mesh_instance)
	mesh_instance.create_trimesh_collision()

func create_block(x, y, z):
	create_face(TOP, x, y, z)
	create_face(BOTTOM, x, y, z)
	create_face(LEFT, x, y, z)
	create_face(RIGHT, x, y, z)
	create_face(FRONT, x, y, z)
	create_face(BACK, x, y, z)

func create_face(i, x, y, z):
	var offset = Vector3(x, y, z)
	var a = vertices[i[0]] + offset
	var b = vertices[i[1]] + offset
	var c = vertices[i[2]] + offset
	var d = vertices[i[3]] + offset
	
	st.add_triangle_fan(([a, b, c]))
	st.add_triangle_fan(([a, c, d]))
