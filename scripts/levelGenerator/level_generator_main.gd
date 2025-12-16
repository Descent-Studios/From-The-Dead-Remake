extends Node3D
class_name LevelGenerator

## DO NOT MODIFY - THIS WILL BE GENERATED AT RUNTIME
@export var house_generate_points : Array[Node3D]
@export var colors_to_use : Array[GameManager.PackageColors]

@export var buildings_to_use : Array[PackedScene]


func _ready():
	house_generate_points = find_houses("house_spawner_point")
	if buildings_to_use.is_empty():
		buildings_to_use = GameManager.return_all_buildings()
	
	GameManager.assign_level_generator(self)
	colors_to_use = GameManager.return_colors()
	generate_level(colors_to_use)

func find_houses(type : String):
	var arr : Array[Node3D]
	
	for child in get_children():
		if child.is_in_group(type):
			arr.append(child)
			
	return arr

func generate_level(colors : Array[GameManager.PackageColors]):
	for point in house_generate_points:
		if randi_range(0,20) >= 18:
			continue
		
		var building : GeneratedHouse = buildings_to_use.pick_random().instantiate()
		building.packageAcceptorType = colors.pick_random()
		building.global_position = point.global_position
		
		add_child(building)
		#point.queue_free()
		
