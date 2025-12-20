extends CharacterBody3D
class_name Player


@export var speed : = 2.0
@export var acceleration : = 2.0
@export var deceleration : = 2.0

@export_group("Animation")
@export var anim_player : AnimationPlayer
@export var anim_tree : AnimationTree
@export var hurt_anim_tree : AnimationTree

@export_group("Visuals")
@export var sprite : Sprite3D
@export var package_sprite : Sprite3D
@export var aim_ring : Node3D
@export var package_visualizer : PackageVisualizer
@export var swear_partiles : GPUParticles3D
var sprite_flip_override := false

@export_group("Walk Params")
@export var walk_particle_controller : GPUParticles3D
@export var fall_particle_controller : GPUParticles3D
@export var can_move : bool = true
var floor_raycast : RayCast3D
var ride_height : float
var spring_strength : float
var spring_dampner : float

#@export_group("Package Settings")
#@export var package_list : Array[PackedScene]

@export_group("Package Throwing")
@export var package_throw_node : Node3D
@export var package : PackedScene
@export var throw_force : float
var package_instance : RigidBody3D
var package_created := false
var package_throw_pos : Vector3
var package_throw_pos_x : float
var _mouse_pos : Vector3
var wants_throw := false

@export_group("Package Pickup")
@export var package_pickup_area : Area3D
@export var package_pickup_radius : float = 0.5
var should_check_packages := false
var packages_in_radius : Array[RigidBody3D]
var closest_package : PackageSmall



@export_group("Player Health Settings")
@export var health_max : int
@export var invincibility_timer : Timer
@export var invincibility_timer_time : float
var cur_health : int


# Priv Inventory 
## Vector2(Package Type, Color from GameManager.Color
@export var package_inventory : Array[Vector2i]

# Priv animation params
var anim_state_machine : AnimationNodeStateMachinePlayback
var hurt_anim_state_machine : AnimationNodeStateMachinePlayback



# Priv walk params
var should_emit_particles_override := false
var was_grounded := false


@onready var gravity = ProjectSettings.get_setting("physics/3d/default_gravity") 

func _ready():
	anim_state_machine = anim_tree["parameters/playback"]
	hurt_anim_state_machine = hurt_anim_tree["parameters/playback"]
	package_throw_pos = package_throw_node.position
	package_throw_pos_x = package_throw_pos.x
	cur_health = health_max
	pass

func _process(_delta):
	if can_move :
		update_player_input()
	#print(cur_health)
	
	pass


func _physics_process(_delta):
	
	#region Velocity based Animation
	if velocity.length() > 0.1:
		if wants_throw : anim_state_machine.travel("throw_walk")
		else : anim_state_machine.travel("walk")
		package_visualizer.start_walk()
	else:
		if wants_throw : anim_state_machine.travel("throw_hold")
		else : anim_state_machine.travel("default")
		walk_particle_controller.set_emitting(false)
		package_visualizer.stop_walk()
		
	if !sprite_flip_override:
		if velocity.x > 0.1:
			sprite.flip_h = false
			package_sprite.flip_h = false
			package_sprite.position.x = -0.345
			package_throw_pos.x = package_throw_pos_x
		elif velocity.x < -0.1:
			sprite.flip_h = true
			#package_sprite.flip_h = true
			package_sprite.position.x = 0.345
			package_throw_pos.x = -package_throw_pos_x
		
	#endregion
	#region particle controller
	if is_on_floor():
		should_emit_particles_override = true
		if !was_grounded:
			was_grounded = true
			fall_particle_controller.set_emitting(true)
			
	else:
		was_grounded = false
		should_emit_particles_override = false
		anim_state_machine.travel("default")
		walk_particle_controller.set_emitting(false)
	#endregion
	
	velocity.y -= gravity * _delta
	if can_move :
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
	if Input.is_action_pressed("throw_package") && (!package_inventory.is_empty() or package_created):
		wants_throw = true
		_mouse_pos = get_mouse_pos_3D()
		aim_ring.show()
		aim_ring_at(_mouse_pos)
		prepare_package()
	elif Input.is_action_just_released("throw_package") && package_created:
		wants_throw = false
		#anim_state_machine.start("throw_anim")
		aim_ring.hide()
		var target_vector = (_mouse_pos - global_position).normalized()
		throw_package(target_vector)
		pass
	#endregion
	
	#region Pickup Package
	if Input.is_action_just_pressed("retrieve_package"):
		if package_inventory.size() < 8:
			closest_package = find_closest_package(packages_in_radius)
			if closest_package:
				anim_state_machine.start("pickup")
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

#region Package Throwing

func prepare_package():
	if !package_created && !package_inventory.is_empty():
		package_created = true
		
		var package_type = package_inventory.pop_back()
		package_visualizer.remove_package()
		
		package_instance = GameManager.get_package(package_type.x).instantiate()
		package_instance.package_color = package_type.y
		#Change color of package
		package_instance.position = package_throw_pos
		package_instance.freeze = true
		
		add_child(package_instance)
	if package_created:
		package_instance.position = package_throw_pos
	pass

func throw_package(towards : Vector3):
	package_instance.reparent(get_parent())
	package_instance.freeze = false
	package_instance.linear_velocity = velocity
	package_instance.apply_impulse(towards * throw_force)
	package_created = false
	pass

func aim_ring_at(vector : Vector3):
	#TODO FIX ORTHONORMALIZATION IG?
	var target_vector := aim_ring.global_position.direction_to(vector)
	var target_basis := Basis.looking_at(target_vector)
	aim_ring.basis = aim_ring.basis.slerp(target_basis, 0.5).orthonormalized()


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
#endregion

#region Package pickup stuff
func on_package_body_enter(_body):
	if !should_check_packages:
		should_check_packages = true
	packages_in_radius.push_back(_body)
	pass

func on_package_body_exit(body):
	if packages_in_radius.has(body):
		packages_in_radius.erase(body)
	if packages_in_radius.is_empty():
		should_check_packages = false
	pass

func find_closest_package(body_array : Array[RigidBody3D]) -> RigidBody3D:
	var closest_body : RigidBody3D
	var closest_distance : float = INF
	for body in body_array:
		var distance = self.global_position.distance_to(body.global_position)
		if distance < closest_distance:
			closest_distance = distance
			closest_body = body
	return closest_body

## Called by pickup animation 
func kill_nearest_package():
	var package_info = Vector2i(closest_package.get_package_type(),closest_package.get_package_color())
	package_inventory.push_back(package_info)
	package_visualizer.add_package(package_info)
	closest_package.queue_free()
	
#endregion

#region Player Damage Functions
func knockback(from : Vector3, multiplier : float):
	var dir = -global_position.direction_to(from).normalized()
	dir.y = 0
	print(dir)
	var force = dir * multiplier
	print(force)
	velocity = force
	pass

func hurt(dmg):
	cur_health -= dmg
	if cur_health <= 0:
		print("oops i died!")
		can_move = false
		anim_state_machine.start("dead",true)
		pass
	pass

func emit_swear():
	swear_partiles.emitting = true

func on_hurtbox_hit(_area : Area3D):
	if invincibility_timer.is_stopped():
		hurt(1)
		var area_global_pos = _area.global_position if _area else self.global_position
		invincibility_timer.start(invincibility_timer_time)
		hurt_anim_state_machine.travel("Hit")
		knockback(area_global_pos,10.0)
	pass # Replace with function body.
#endregion
