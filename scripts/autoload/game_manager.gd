extends Node

const Colors : Dictionary = {
	RED = Color("ff0000"),
	GREEN = Color("00ff00"),
	BLUE = Color("0000ff")
}

enum PackageType {
	SMALL = 1,
	MEDIUM = 2
}

var small_package_scene : PackedScene = preload("res://scenes/Packages/package_init.tscn")


func get_package(type : PackageType) -> PackedScene:
	match type:
		PackageType.SMALL:
			return small_package_scene
		_:
			return null
