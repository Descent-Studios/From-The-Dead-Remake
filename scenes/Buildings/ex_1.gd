extends Node3D

@export var packageAcceptorArea : Area3D
@export var packageAcceptorType : GameManager.PackageColors
@export var door : CSGBox3D

var doorColor

func _ready():
	doorColor = GameManager.get_color(packageAcceptorType)
	
	var col_shape = packageAcceptorArea.get_child(0) as CollisionShape3D
	col_shape.debug_color = doorColor
	door.material.albedo_color = doorColor

func initialize_delivery_area(deliveryColor : GameManager.PackageColors):
	packageAcceptorType = deliveryColor
	
	doorColor = GameManager.get_color(deliveryColor)
	
	var col_shape = packageAcceptorArea.get_child(0) as CollisionShape3D
	col_shape.debug_color = doorColor
	door.material.albedo_color = doorColor

func check_package(_body : PackageSmall):
	if _body.has_method("get_package_color"):
		print(_body.get_package_color())
	pass

func _on_package_acceptor_body_entered(body):
	check_package(body)
	pass # Replace with function body.
