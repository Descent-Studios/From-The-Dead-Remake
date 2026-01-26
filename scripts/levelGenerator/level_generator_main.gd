extends Node3D
class_name LevelGenerator


@export_group("Level Info")
@export var colors_to_generate : int = 1
@export var packages_to_deliver : int = 1
@export var player_start_pos : Node3D
@export var anim_tree : AnimationTree
var anim_state : AnimationNodeStateMachinePlayback

@export_group("Level Generation config")
@export var house_generate_tree : Node3D
## DO NOT MODIFY - THIS WILL BE GENERATED AT RUNTIME
@export var house_generate_points : Array[Node3D]
## DO NOT MODIFY - THIS WILL BE GENERATED AT RUNTIME
@export var colors_to_use : Array[GameManager.PackageColors]

@export var buildings_to_use : Array[PackedScene]
var decorations : Array[PackedScene]
var colorsUsed : Array[GameManager.PackageColors]

@export var nagivation_layer : NavigationRegion3D


func _ready():
	house_generate_points = find_houses("house_spawner_point")
	if buildings_to_use.is_empty():
		buildings_to_use = GameManager.return_all_buildings()
	decorations = GameManager.return_all_decorations()
	GameManager.initialize(colors_to_generate)
	GameManager.assign_level_generator(self)
	colors_to_use = GameManager.return_colors()
	generate_level(colors_to_use)
	anim_state = anim_tree["parameters/playback"]

func find_houses(type : String):
	var arr : Array[Node3D]
	
	for child in house_generate_tree.get_children():
		if child.is_in_group(type):
			arr.append(child)
			
	return arr

func generate_level(colors : Array[GameManager.PackageColors]):
	print_debug("Generating Level with Colors : ", colors)
	print_debug("Using points : ", house_generate_points)
	while(colorsUsed.is_empty()):
		for point in house_generate_points:
			if randi_range(1,20) >= 16:
				var decoration : Node3D = decorations.pick_random().instantiate()
				decoration.global_position = point.global_position
				# Add deco to navigation layer
				nagivation_layer.add_child(decoration)
				continue
			
			var building : GeneratedHouse = buildings_to_use.pick_random().instantiate()
			var colorPicked = colors.pick_random()
			building.packageAcceptorType = colorPicked
			building.global_position = point.global_position
			
			if !colorsUsed.has(colorPicked): colorsUsed.append(colorPicked)
			# Add building to navigation layer
			nagivation_layer.add_child(building)
			
	SignalBus.level_generated.emit(colorsUsed, packages_to_deliver)
	
	self.call_deferred("generate_nav")

func call_player_drop():
	SignalBus.initiate_player.emit(player_start_pos.global_position)

func _unhandled_input(event):
	if event.is_action_pressed("ui_end"):
		generate_nav()

func generate_nav():
	await get_tree().physics_frame
	nagivation_layer.bake_navigation_mesh(true)
	self.call_deferred("start_level")

func start_level():
	# Start level animation after everything has been loaded properly
	anim_state.travel("level_start")
