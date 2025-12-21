extends Node3D
class_name LevelGenerator


@export_group("Level Info")
@export var colors_to_generate : int = 1
@export var packages_to_deliver : int = 1
@export var player_start_pos : Node3D


@export_group("Level Generation config")
@export var house_generate_tree : Node3D
## DO NOT MODIFY - THIS WILL BE GENERATED AT RUNTIME
@export var house_generate_points : Array[Node3D]
## DO NOT MODIFY - THIS WILL BE GENERATED AT RUNTIME
@export var colors_to_use : Array[GameManager.PackageColors]

@export var buildings_to_use : Array[PackedScene]
var decorations : Array[PackedScene]
var colorsUsed : Array[GameManager.PackageColors]



func _ready():
	house_generate_points = find_houses("house_spawner_point")
	if buildings_to_use.is_empty():
		buildings_to_use = GameManager.return_all_buildings()
	decorations = GameManager.return_all_decorations()
	GameManager.initialize(colors_to_generate)
	GameManager.assign_level_generator(self)
	colors_to_use = GameManager.return_colors()
	generate_level(colors_to_use)

func find_houses(type : String):
	var arr : Array[Node3D]
	
	for child in house_generate_tree.get_children():
		if child.is_in_group(type):
			arr.append(child)
			
	return arr

func generate_level(colors : Array[GameManager.PackageColors]):
	print_debug("Generating Level with Colors : ", colors)
	print_debug("Using points : ", house_generate_points)
	for point in house_generate_points:
		if randi_range(0,20) >= 15:
			var decoration : Node3D = decorations.pick_random().instantiate()
			decoration.global_position = point.global_position
			add_child(decoration)
			continue
		
		var building : GeneratedHouse = buildings_to_use.pick_random().instantiate()
		var colorPicked = colors.pick_random()
		building.packageAcceptorType = colorPicked
		building.global_position = point.global_position
		
		if !colorsUsed.has(colorPicked): colorsUsed.append(colorPicked)
		
		add_child(building)
		#point.queue_free()
		
	SignalBus.level_generated.emit(colorsUsed, packages_to_deliver)

func call_player_drop():
	SignalBus.initiate_player.emit(player_start_pos.global_position)
