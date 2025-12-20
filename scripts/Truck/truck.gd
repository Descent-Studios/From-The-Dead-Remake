extends Node3D
class_name Truck

@export var package_scene : PackedScene
@export var summon_start : Node3D
@export var summon_spacing : float
@export var length : int
@export var width : int
@export var height : int

var packages : Array[RigidBody3D]
var colors_to_use : Array[GameManager.PackageColors]

var spawned := false


func _ready():
	GameManager.truck = self
	

func unfreeze_packages():
	for x in packages:
		if x:
			x.reparent(get_parent())
			x.freeze = false
			

func distribute_packages(amt):
	var spawned_packages = 0
	
	if spawned:
		return
	for i in range(length):
		for j in range(width):
			for k in range(height):
				var package_color = colors_to_use.pick_random()
				var package : PackageSmall = GameManager.get_package(GameManager.PackageType.SMALL).instantiate()
				package.package_color = package_color
				packages.push_front(package)
				package.position = summon_start.position + Vector3(summon_spacing * i, summon_spacing * j, summon_spacing * k)
				add_child.call_deferred(package)
				spawned_packages += 1
				if spawned_packages >= amt: 
					spawned = true
					return
	spawned = true
