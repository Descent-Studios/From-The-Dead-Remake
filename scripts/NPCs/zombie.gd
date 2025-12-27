extends CharacterBody3D

@export var nav_agent : NavigationAgent3D

func _unhandled_input(event):
	if event.is_action_pressed("ui_accept"):
		var ran_pos := self.global_position
		ran_pos.x += randf_range(-5,5)
		ran_pos.z += randf_range(-5,5)
		nav_agent.set_target_position(ran_pos)

func _physics_process(_delta):
	var destination = nav_agent.get_next_path_position()
	var local_destination = destination - global_position
	var direction = local_destination.normalized()
	
	velocity = direction * 5
	move_and_slide()
