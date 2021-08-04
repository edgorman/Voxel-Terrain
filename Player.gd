extends KinematicBody

onready var head = $Head
onready var camera = $Head/Camera

var camera_x_rotation = 0

const mouse_sensitivity = 0.3
const movement_speed = 10
const gravity = 20
const jump_velocity = 10

var velocity = Vector3()

var paused = false

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if Input.is_action_just_pressed("Pause"):
		paused = not paused
		if paused:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	if paused:
		return
	
	if event is InputEventMouseMotion:
		head.rotate_y(deg2rad(-event.relative.x * mouse_sensitivity))
		
		var delta_x = event.relative.y * mouse_sensitivity
		if camera_x_rotation + delta_x > -90 and camera_x_rotation + delta_x < 90:
			camera.rotate_x(deg2rad(-delta_x))
			camera_x_rotation += delta_x

func _physics_process(delta):
	if paused:
		return
	
	var basis = head.get_global_transform().basis
	
	var direction = Vector3()
	
	if Input.is_action_pressed("Forward"):
		direction -= basis.z
	if Input.is_action_pressed("Backward"):
		direction += basis.z
	if Input.is_action_pressed("Left"):
		direction -= basis.x
	if Input.is_action_pressed("Right"):
		direction += basis.x
		
	velocity.z = direction.z * movement_speed
	velocity.x = direction.x * movement_speed
	
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = jump_velocity
	
	velocity.y -= gravity * delta
	velocity = move_and_slide(velocity, Vector3.UP)

