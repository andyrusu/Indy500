extends CharacterBody2D
class_name CarController

@export var wheel_base : int = 70
@export var steering_angle : int = 15
@export var engine_power : int = 800
@export var friction : float = -0.9
@export var drag : float = -0.001
@export var breaking : int = -450
@export var max_reverse_speed : int = 250
@export var slip_speed = 400
@export var traction_fast = 0.1
@export var traction_slow = 0.7

var acceleration : Vector2 = Vector2.ZERO
var steer_direction

func _physics_process(delta):
	acceleration = Vector2.ZERO
	steer_direction = calculate_steer_direction(Input.is_action_pressed("steer_left"), Input.is_action_pressed("steer_right"))
	
	if Input.is_action_pressed("accelarate"):
		acceleration = transform.x * engine_power
	elif Input.is_action_pressed("break"):
		acceleration = transform.x * breaking
	
	apply_drag_and_friction()
	calculate_steering(delta)
	
	velocity += acceleration * delta
	move_and_slide()

func apply_drag_and_friction():
	if velocity.length() < 5:
		velocity = Vector2.ZERO
	
	var friction_force : Vector2 = velocity * friction
	var drag_force : Vector2 = velocity * velocity.length() * drag
	
	acceleration += drag_force + friction_force

func calculate_steer_direction(steer_left, steer_right):
	var turn : int = 0
	
	if steer_right:
		turn += 1
	elif steer_left:
		turn -= 1
	
	return turn * deg_to_rad(steering_angle)
	
	

func calculate_steering(delta):
	var rear_wheele : Vector2 = position - transform.x * wheel_base / 2.0
	var front_wheele : Vector2 = position + transform.x * wheel_base / 2.0
	
	rear_wheele += velocity * delta
	front_wheele += velocity.rotated(steer_direction) * delta
	
	var new_heading = rear_wheele.direction_to(front_wheele)
	
	var traction = traction_slow
	if velocity.length() > slip_speed:
		traction = traction_fast
	
	var d = new_heading.dot(velocity.normalized())
	
	if (d > 0):
		velocity = velocity.lerp(new_heading * velocity.length(), traction)
	elif (d < 0):
		velocity = -new_heading * min(velocity.length(), max_reverse_speed)
	
	rotation = new_heading.angle()
