extends Node


enum PackageColors {
	NONE = -1,
	RED = 0,
	GREEN = 1,
	BLUE = 2
}

const ColorDict : Dictionary = {
	PackageColors.NONE : Color("#000000"),
	PackageColors.RED : Color("ff0000"),
	PackageColors.GREEN : Color("00ff00"),
	PackageColors.BLUE : Color("0000ff"),
}

enum PackageType {
	SMALL = 1,
	MEDIUM = 2
}


var level_generator : LevelGenerator
@export var truck : Truck
var building_path = "res://scenes/Buildings/"
var decoration_path = "res://scenes/Decorations/"

var small_package_scene : PackedScene = preload("res://scenes/Packages/package_init.tscn")

var selectedColors : Array[PackageColors]

func _ready():
	SignalBus.level_generated.connect(level_generated)
	#truck = get_tree().get_nodes_in_group("truck")[0]
	initialize(3)
	


func initialize(colorCount : int):
	var colors : Array[PackageColors] = []
	for i in range(colorCount):
		var color = PackageColors.values().pick_random()
		if not colors.has(color):
			colors.append(color)
	print_debug(colors)
	selectedColors = colors

func reset():
	level_generator = null
	selectedColors = []


func return_all_buildings() -> Array[PackedScene]:
	var buildings : Array[PackedScene] = []
	var dir = DirAccess.open(building_path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				print("Found directory: " + file_name)
			else:
				if file_name.get_extension() == "tscn":
					var full_path = building_path.path_join(file_name)
					buildings.append(load(full_path))
			file_name = dir.get_next()
	else:
		print_debug("An error occurred when trying to access the path.")
	return buildings

func return_all_decorations() -> Array[PackedScene]:
	var decorations : Array[PackedScene] = []
	var dir = DirAccess.open(decoration_path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				print("Found directory: " + file_name)
			else:
				if file_name.get_extension() == "tscn":
					var full_path = decoration_path.path_join(file_name)
					decorations.append(load(full_path))
			file_name = dir.get_next()
	else:
		print_debug("An error occurred when trying to access the path.")
	return decorations

func assign_level_generator(levelGenerator) -> void:
	level_generator = levelGenerator

## Maximum of 45
func level_generated(colorsUsed):
	selectedColors = colorsUsed
	truck.colors_to_use = selectedColors
	distribute_packages(12)
	pass

func assign_truck(_truck) -> void:
	truck = _truck
	truck.colors_to_use = selectedColors

func distribute_packages(amt) -> void:
	print_debug("test")
	truck.distribute_packages(amt)

func return_colors() -> Array[PackageColors]:
	return selectedColors

func get_color(packageColor : PackageColors):
	return ColorDict[packageColor]

func get_package(type : PackageType) -> PackedScene:
	match type:
		PackageType.SMALL:
			return small_package_scene
		_:
			return null
