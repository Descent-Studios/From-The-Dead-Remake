extends CharacterBody3D
class_name Player


@export var speed : = 2.0
@export var acceleration : = 2.0
@export var deceleration : = 2.0

@export_group("Animation")
@export var anim_player : AnimationPlayer
@export var anim_tree : AnimationTree

@export_group("Visuals")
@export var sprite : Sprite3D
@export var aim_ring : Node3D

@export_group("Walk Params")
@export var walk_particle_controller : GPUParticles3D
@export var fall_particle_controller : GPUParticles3D
var floor_raycast : RayCast3D
var ride_height : float
var spring_strength : float
var spring_dampner : float

@export_group("Package Throwing")
@export var package_throw_node : Node3D
@export var package_instance : PackedScene
@export var throw_force : float
var package_throw_pos : Vector3
var _mouse_pos : Vector3


# Priv animation params
var anim_state_machine : AnimationNodeStateMachinePlayback



# Priv walk params
var should_emit_particles_override := false
var was_grounded := false


@onready var gravity = ProjectSettings.get_setting("physics/3d/default_gravity") 

func _ready():
	anim_state_machine = anim_tree["parameters/playback"]
	package_throw_pos = package_throw_node.position
	pass

func _process(_delta):
	update_player_input()
	
	
	pass


func _physics_process(_delta):
	
	if velocity.length() > 0.1:
		anim_state_machine.travel("walk_anim")
		pass
	else:
		anim_state_machine.travel("idle_anim")
		walk_particle_controller.set_emitting(false)
		
	
	if velocity.x > 0.1:
		sprite.flip_h = false
	elif velocity.x < -0.1:
		sprite.flip_h = true
	
	if is_on_floor():
		should_emit_particles_override = true
		if !was_grounded:
			was_grounded = true
			fall_particle_controller.set_emitting(true)
			
	else:
		was_grounded = false
		should_emit_particles_override = false
		anim_state_machine.travel("idle_anim")
		walk_particle_controller.set_emitting(false)
	
		
	velocity.y -= gravity * _delta
	update_input_mkb(_delta)
	
	
	move_and_slide()
	pass

func update_input_mkb(_delta) -> void:
	var input_dir = Input.get_vector("move_left","move_right","move_up","move_down")
	var dir = (transform.basis * Vector3(input_dir.x,0,input_dir.y)).normalized()
	var wanted_vel := velocity
	if dir:
		wanted_vel.x = lerp(wanted_vel.x, dir.x * speed, acceleration)
		wanted_vel.z = lerp(wanted_vel.z, dir.z * speed, acceleration)
		walk_particle_controller.set_emitting(should_emit_particles_override)
		#wanted_vel.x = dir.x * speed
		#wanted_vel.z = dir.z * speed
		
	else:
		wanted_vel.x = move_toward(wanted_vel.x, 0, deceleration)
		wanted_vel.z = move_toward(wanted_vel.z, 0, deceleration)
	#var speed_vector = Vector3(speed,velocity.y,speed)
	#wanted_vel.clamp(-speed_vector, speed_vector)
	velocity = wanted_vel
	
func update_player_input():
	
	#region Throw package
	if Input.is_action_pressed("throw_package"):
		_mouse_pos = get_mouse_pos_3D()
		aim_ring.show()
		aim_ring_at(_mouse_pos)
	elif Input.is_action_just_released("throw_package"):
		aim_ring.hide()
		var target_vector = (_mouse_pos - global_position).normalized()
		throw_package(target_vector)
		pass
	#endregion

func raycast_player_height(ray_hit_distance):
	var vel = velocity 
	var rayDir = Vector3.DOWN
	
	var rayDirVel = rayDir.dot(vel)
	var x = ray_hit_distance - ride_height
	
	var spring_force = (x * spring_strength) - (rayDirVel * spring_dampner)
	
	var force = rayDir * spring_force
	
	velocity += force
	pass

func throw_package(towards : Vector3):
	var instance : RigidBody3D = package_instance.instantiate()
	instance.global_position = global_position + package_throw_pos
	get_parent().add_child(instance)
	instance.apply_impulse(towards * throw_force)
	
	pass

func aim_ring_at(vector : Vector3):
	var target_vector := aim_ring.global_position.direction_to(vector)
	var target_basis := Basis.looking_at(target_vector)
	aim_ring.basis = aim_ring.basis.slerp(target_basis, 0.5)


func get_mouse_pos_3D() -> Vector3:
	
	#region Find mouse in 3D space
	var viewport := get_viewport()
	var mouse_pos := viewport.get_mouse_position()
	var camera := viewport.get_camera_3d()
	
	var origin := camera.project_ray_origin(mouse_pos)
	var dir := camera.project_ray_normal(mouse_pos)
	
	var ray_length := 200
	var end := origin + dir * ray_length
	
	var space_state := get_world_3d().direct_space_state
	var query := PhysicsRayQueryParameters3D.create(origin, end)
	query.set_collision_mask(0x0001)
	var result := space_state.intersect_ray(query)
	
	#endregion
	var mouse_pos_3D : Vector3 = result.get("position",end)
	
	return mouse_pos_3D
