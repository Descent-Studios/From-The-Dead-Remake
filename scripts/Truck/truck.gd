extends Node3D
class_name Truck

@export var package_scene : PackedScene
@export var summon_start : Node3D
@export var summon_spacing : float
@export var length : int
@export var width : int
@export var height : int

var packages : Array[RigidBody3D]

var spawned := false


func _ready():
	distribute_packages()



func unfreeze_packages():
	for x in packages:
		if x:
			x.reparent(get_parent())
			x.freeze = false
			



func distribute_packages():
	
	for i in range(length):
		for j in range(width):
			for k in range(height):
				var package : RigidBody3D = package_scene.instantiate()
				packages.push_front(package)
				package.position = summon_start.position + Vector3(summon_spacing * i, summon_spacing * j, summon_spacing * k)
				add_child.call_deferred(package)
				#package.freeze = false
	
	pass
