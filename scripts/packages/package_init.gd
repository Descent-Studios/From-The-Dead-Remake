extends RigidBody3D
class_name PackageSmall


@export var velocity_threshold : float = 2.0
var previous_velocity : float

@export var collider_particle : GPUParticles3D

@export var package_mesh_node : MeshInstance3D

@export var package_type : GameManager.PackageType = GameManager.PackageType.SMALL

@export var package_color : GameManager.PackageColors = GameManager.PackageColors.RED

var deactivated := false
func _ready():
	change_mesh_color(GameManager.get_color(package_color))

func _physics_process(_delta):
	previous_velocity = linear_velocity.length()

func _on_body_entered(_body):
	#region Package particle check
	var vel_length = linear_velocity.length()
	if (previous_velocity - vel_length) > velocity_threshold:
		var state := PhysicsServer3D.body_get_direct_state(self.get_rid())
		collider_particle.global_position = state.get_contact_collider_position(0)
		collider_particle.rotation = state.get_contact_local_normal(0) * 180 / PI
		collider_particle.set_emitting(true)
		set_collision_mask_value(2, true)
	#endregion

func change_mesh_color(color : Color = Color("#000000")):
	var percentage : float
	if package_mesh_node:
		match color:
			Color("#000000"): percentage = 0.0
			_: percentage = 0.50
		
		package_mesh_node.set_instance_shader_parameter("color",color)
		package_mesh_node.set_instance_shader_parameter("percentage", percentage)
	pass
	

func get_package_color() -> GameManager.PackageColors:
	return package_color

func get_package_type() -> GameManager.PackageType:
	return package_type
	#Yeah thats... all this method does...

func toggle_activation():
	self.freeze = !self.freeze
