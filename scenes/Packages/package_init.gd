extends RigidBody3D
class_name PackageSmall


@export var velocity_threshold : float = 2.0
var previous_velocity : float

@export var collider_particle : GPUParticles3D

@export var package_mesh_node : MeshInstance3D

@export var package_type : GameManager.PackageType

var deactivated := false

func _physics_process(delta):
	previous_velocity = linear_velocity.length()

func _process(delta):
	if Input.is_key_pressed(KEY_F):
		change_mesh_color(Color("#ff00ff"))

func _on_body_entered(body):
	var vel_length = linear_velocity.length()
	if (previous_velocity - vel_length) > velocity_threshold:
		var state := PhysicsServer3D.body_get_direct_state(self.get_rid())
		collider_particle.global_position = state.get_contact_collider_position(0)
		collider_particle.rotation = state.get_contact_local_normal(0) * 180 / PI
		collider_particle.set_emitting(true)
		set_collision_mask_value(2, true)
	pass # Replace with function body.

func change_mesh_color(color : Color):
	package_mesh_node.material_override.albedo_color = color
	pass

func get_package_type() -> GameManager.PackageType:
	return package_type
	#Yeah thats... all this method does...
