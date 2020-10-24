extends KinematicBody

export var gravity = Vector3.DOWN * 10
export var speed = 8
export var rot_speed = 0.85
var velocity = Vector3.ZERO

func align_with_y(xform, new_y):
	xform.basis.y = new_y
	xform.basis.x = -xform.basis.z.cross(new_y)
	xform.basis = xform.basis.orthonormalized()
	return xform
	
func _physics_process(delta):
	velocity += gravity * delta
	get_input(delta)
	velocity = move_and_slide_with_snap(velocity, Vector3.DOWN*2, Vector3.UP, true)
	#for i in get_slide_count():
		#var c = get_slide_collision(i)
		#global_transform = align_with_y(global_transform, c.normal)
	var n = $RayCast.get_collision_normal()
	var xform = align_with_y(global_transform, n)
	global_transform = global_transform.interpolate_with(xform, 0.2)

func get_input(delta):
	velocity = Vector3()
	if Input.is_action_pressed(("move_forward")):
		velocity += transform.basis.z * speed
	if Input.is_action_pressed(("move_back")):
		velocity += -transform.basis.z * speed
	if Input.is_action_pressed(("strafe_right")):
		#velocity += -transform.basis.x * speed
		rotate_y(-rot_speed * delta)
	if Input.is_action_pressed(("strafe_left")):
		#velocity += transform.basis.x * speed
		rotate_y(rot_speed * delta)
