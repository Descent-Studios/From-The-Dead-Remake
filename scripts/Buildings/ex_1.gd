extends Node3D

class_name GeneratedHouse

@export var active := true
@export var packageAcceptorArea : Area3D
@export var packageAcceptorType : GameManager.PackageColors
@export var door : Node3D

var doorColor

func _ready():
	doorColor = GameManager.get_color(packageAcceptorType)
	
	var col_shape = packageAcceptorArea.get_child(0) as CollisionShape3D
	col_shape.debug_color = doorColor
	door.set_instance_shader_parameter("albedo", doorColor)

func initialize_delivery_area(deliveryColor : GameManager.PackageColors):
	packageAcceptorType = deliveryColor
	
	doorColor = GameManager.get_color(deliveryColor)
	
	door.set_instance_shader_parameter("albedo", doorColor)

func check_package(_body : PackageSmall):
	if _body.has_method("get_package_color"):
		if packageAcceptorType == _body.get_package_color():
			# tell game manager 
			_body.queue_free()
		#else:
			# play a sound? idk yet


func _on_package_acceptor_body_entered(body):
	if active:
		check_package(body)
