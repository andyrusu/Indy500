extends CharacterBody2D
class_name CarController

@export var vehicle : BasicVehicle

@onready var sprite : Sprite2D = $Sprite

func _ready():
	sprite.texture = vehicle.texture

func _physics_process(delta):
	vehicle.init(velocity, position, transform.x)
	vehicle.set_inputs(
		Input.is_action_pressed("accelarate"), 
		Input.is_action_pressed("break"), 
		Input.is_action_pressed("steer_left"), 
		Input.is_action_pressed("steer_right")
	)
	# rav = {rotation, velocity}
	var rav = vehicle.run(delta)
	rotation = rav.rotation
	velocity = rav.velocity
	move_and_slide()
