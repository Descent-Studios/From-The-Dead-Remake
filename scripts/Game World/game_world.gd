extends Node3D

@export var procedural_levels : Array[Level_Order]
@export var default_level : PackedScene

@export var current_level : Node3D

var current_level_idx := 0

func _ready() -> void:
	pass
	SignalBus.loading_level_start.connect(generate_level)

func find_next_level() -> PackedScene:
	if procedural_levels[current_level_idx + 1]:
		current_level_idx += 1
		return procedural_levels[current_level_idx].level
	return default_level

func find_level_number(number) -> PackedScene:
	for level in procedural_levels:
		if level.order == number:
			return level.level
	return default_level

func generate_level(restart : bool = false):
	print("starting generating new level...")
	print("waiting for screen to hide...")
	await SignalBus.level_transition_finish
	print("screen hidden")
	SignalBus.deinitialize_player.emit()
	if current_level:
		# delete zombies and stray packages too. but later
		current_level.queue_free()
	var new_level_scene : PackedScene
	if restart:
		new_level_scene = find_level_number(current_level_idx)
	else:
		new_level_scene = find_next_level()
	current_level = new_level_scene.instantiate()
	self.add_child(current_level)
	print("level done!")
	SignalBus.level_transition_show.emit()
	
	
