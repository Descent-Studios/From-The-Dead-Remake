extends RigidBody3D


@export var velocity_threshold : float = 2.0
var previous_velocity : float

@export var collider_particle : GPUParticles3D

var deactivated := false

func _physics_process(delta):
	previous_velocity = linear_velocity.length()
	
	


func _on_body_entered(body):
	var vel_length = linear_velocity.length()
	if (previous_velocity - vel_length) > velocity_threshold:
		var state := PhysicsServer3D.body_get_direct_state(self.get_rid())
		collider_particle.global_position = state.get_contact_collider_position(0)
		collider_particle.rotation = state.get_contact_local_normal(0) * 180 / PI
		collider_particle.set_emitting(true)
		set_collision_mask_value(2, true)
	pass # Replace with function body.


func call_change_color(color : GameManager.Colors):
	match color:
		RED:
			


func change_mesh_color(color):
	
