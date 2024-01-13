extends Resource
class_name BasicVehicle

@export_group("Visual Properties")
@export var texture : Texture2D
@export_group("Driving Properties")
@export var wheel_base : int = 70
@export var steering_angle : int = 15
@export var engine_power : int = 800
@export var friction : float = -0.9
@export var drag : float = -0.001
@export var breaking : int = -450
@export var max_reverse_speed : int = 250
@export var slip_speed : int = 400
@export var traction_fast : float = 0.1
@export var traction_slow : float = 0.7

var velocity : Vector2 = Vector2.ZERO
var acceleration : Vector2 = Vector2.ZERO
var position : Vector2 = Vector2.ZERO
var steer_direction : float = 0.0
var transform_x : Vector2 = Vector2.ZERO

# Inputs
var input_accelarate : bool = false
var input_break : bool = false
var input_steer_left : bool = false
var input_steer_right : bool = false

func init(new_velocity : Vector2, new_position : Vector2, new_transform_x : Vector2):
	velocity = new_velocity
	position = new_position
	transform_x = new_transform_x

func set_inputs(accelarate : bool, decelarate : bool, steer_left  : bool, steer_right : bool):
	input_accelarate = accelarate
	input_break = decelarate
	input_steer_left = steer_left
	input_steer_right = steer_right

func run(delta : float):
	acceleration = Vector2.ZERO
	steer_direction = calculate_steer_direction(input_steer_left, input_steer_right)
	
	if input_accelarate:
		acceleration = transform_x * engine_power
	elif input_break:
		acceleration = transform_x * breaking
	
	acceleration += apply_drag_and_friction()
	var rotation = calculate_steering(delta)
	
	velocity += acceleration * delta
	
	return {"rotation": rotation, "velocity": velocity}

func apply_drag_and_friction() -> Vector2:
	if velocity.length() < 5:
		velocity = Vector2.ZERO
	
	var friction_force : Vector2 = velocity * friction
	var drag_force : Vector2 = velocity * velocity.length() * drag
	
	return drag_force + friction_force

func calculate_steer_direction(steer_left : bool, steer_right : bool) -> float:
	var turn : int = 0
	
	if steer_right:
		turn += 1
	elif steer_left:
		turn -= 1
	
	return turn * deg_to_rad(steering_angle)

func calculate_steering(delta : float) -> float:
	var rear_wheele : Vector2 = position - transform_x * wheel_base / 2.0
	var front_wheele : Vector2 = position + transform_x * wheel_base / 2.0
	
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
	
	return new_heading.angle()
