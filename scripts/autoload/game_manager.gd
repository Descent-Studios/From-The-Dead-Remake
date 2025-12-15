extends Node

enum PackageColors {
	RED = 0,
	GREEN = 1,
	BLUE = 2
}

const ColorDict : Dictionary = {
	PackageColors.RED : Color("ff0000"),
	PackageColors.GREEN : Color("00ff00"),
	PackageColors.BLUE : Color("0000ff"),
}

enum PackageType {
	SMALL = 1,
	MEDIUM = 2
}

var small_package_scene : PackedScene = preload("res://scenes/Packages/package_init.tscn")

func get_color(packageColor : PackageColors):
	return ColorDict[packageColor]


func get_package(type : PackageType) -> PackedScene:
	match type:
		PackageType.SMALL:
			return small_package_scene
		_:
			return null
