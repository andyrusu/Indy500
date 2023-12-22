extends CharacterBody2D
class_name CarController

@export var wheel_base = 70
@export var steering_angle = 15

var steer_direction

func _physics_process(delta):
	steer_direction = calculate_steer_direction(Input.is_action_pressed("steer_left"), Input.is_action_pressed("steer_right"))
	
	if Input.is_action_pressed("accelarate"):
		velocity = transform.x * 500
	
	calculate_steering(delta)
	
	move_and_slide()


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
	
	velocity = new_heading * velocity.length()
	
	rotation = new_heading.angle()
