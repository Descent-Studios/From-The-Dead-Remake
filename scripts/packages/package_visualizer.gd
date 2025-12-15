extends SubViewport
class_name PackageVisualizer

@export var package_inventory : Array[Vector2i]
@export var hole : Node3D
@export var animation_tree : AnimationTree

@export var package_spawn_pos : Node3D

var active_packages : Array[RigidBody3D]
var anim_state_machine : AnimationNodeStateMachinePlayback

func _ready():
	anim_state_machine = animation_tree["parameters/playback"]


func add_package(package_info : Vector2i):
	package_inventory.push_back(package_info)
	
	var package_instance : PackageSmall = GameManager.get_package(package_info.x).instantiate()
	package_instance.package_color = package_info.y as GameManager.PackageColors
	active_packages.push_back(package_instance)
	
	package_instance.position = package_spawn_pos.position
	package_instance.axis_lock_linear_x = true
	package_instance.axis_lock_linear_z = true
	package_instance.freeze = false
	
	package_spawn_pos.position.y = package_spawn_pos.position.y + 0.5
	hole.add_child(package_instance)
	#spawn package
	pass

func remove_package():
	print(active_packages)
	package_inventory.pop_back()
	if !active_packages.is_empty():
		var package_instance = active_packages.pop_back()
		package_instance.queue_free()
		
		package_spawn_pos.position.y = maxf(package_spawn_pos.position.y - 0.5, 0.7)
	
	
	pass

func start_walk():
	anim_state_machine.travel("bob")

func stop_walk():
	anim_state_machine.travel("RESET")
