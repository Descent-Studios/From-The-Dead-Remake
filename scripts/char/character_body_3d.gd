extends CharacterBody3D
class_name Player


@export var speed : = 2.0
@export var acceleration : = 2.0
@export var deceleration : = 2.0


@onready var gravity = ProjectSettings.get_setting("physics/3d/default_gravity") 

func _ready():
	pass

func _process(_delta):
	
	velocity.y -= gravity * _delta
	update_input_mkb(_delta)
	
	move_and_slide()
	pass


func _physics_process(_delta):
	
	if velocity.x > 0.0:
		# flip visuals
		pass
	elif velocity.x < 0.0:
		#flip visuals
		pass
	
	pass

func update_input_mkb(delta) -> void:
	var input_dir = Input.get_vector("move_left","move_right","move_up","move_down")
	var dir = (transform.basis * Vector3(input_dir.x,0,input_dir.y)).normalized()
	var wanted_vel := velocity
	if dir:
		#wanted_vel.x = lerp(wanted_vel.x, dir.x * speed, acceleration)
		#wanted_vel.z = lerp(wanted_vel.z, dir.z * speed, acceleration)
		wanted_vel.x = dir.x * speed
		wanted_vel.z = dir.z * speed
	else:
		wanted_vel.x = move_toward(wanted_vel.x, 0, deceleration)
		wanted_vel.z = move_toward(wanted_vel.z, 0, deceleration)
	var speed_vector = Vector3(speed,velocity.y,speed)
	wanted_vel.clamp(-speed_vector, speed_vector)
	velocity = wanted_vel
	
