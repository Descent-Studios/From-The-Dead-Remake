extends CharacterBody3D

@export_group("External Nodes")
@export var nav_agent : NavigationAgent3D
@export var wander_timer : Timer
@export var timer_progress_bar : ProgressBar
@export var awareness_radius : Area3D

var has_target := false
enum track_type {
	DEFAULT,
	PLAYER,
	PACKAGE
}
var constant_track = false
var target_node : Node3D

@export_category("Movement Settings")
@export var speed := 5.0
@export var accerlation := 1.0
@export var deceleration := 1.0


@export_category("Wander Time Range")
@export var wanderTimerRangeLow := 1.0
@export var wanderTimerRangeHigh := 10.0
@export_category("Wander Distance Range")
@export var wander_range_low := -1.0
@export var wander_range_high := 1.0


var wait_time = 0.0

func _physics_process(_delta):
	if has_target:
		var next_path_pos := nav_agent.get_next_path_position()
		var dir := global_position.direction_to(next_path_pos)
		if dir:
			velocity.x = lerp(velocity.x, dir.x * speed, accerlation)
			velocity.z = lerp(velocity.z, dir.z * speed, accerlation)
		if nav_agent.is_navigation_finished():
			has_target = false
			check_wander()
	else:
		velocity.x = move_toward(velocity.x, 0.0, deceleration)
		velocity.z = move_toward(velocity.z, 0.0, deceleration)
		# rotate sprite to face correct direction
	
	if wander_timer:
		var time_div = (wait_time - wander_timer.time_left) / wait_time * 100
		timer_progress_bar.value = time_div
	
	if constant_track and target_node:
		match constant_track:
			track_type.PACKAGE: 
				if !target_node.in_air:
					constant_track = false
				has_target = true
			
			track_type.PLAYER: 
				has_target = true
			
			_: 
				has_target = true
			
		nav_agent.target_position = target_node.global_position
	
	move_and_slide()	
		

#region Wandering
func check_wander():
	#check to see if player is in radius
	var bodies = awareness_radius.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("Player"):
			assign_body_as_target(body,track_type.PLAYER)
			return
	
	start_wander_timer()
	
func start_wander_timer():
	var time = randf_range(wanderTimerRangeLow, wanderTimerRangeHigh)
	wander_timer.start(time)
	wait_time = time

func _on_wander_timer_timeout():
	var ran_pos := self.global_position
	ran_pos.x += randf_range(wander_range_low, wander_range_high)
	ran_pos.z += randf_range(wander_range_low, wander_range_high)
	nav_agent.set_target_position(ran_pos)
	has_target = true
#endregion

#region Awareness

func assign_body_as_target(body: Node3D, type = true):
	wander_timer.stop()
	constant_track = type
	target_node = body


func _on_awareness_radius_body_entered(body : Node3D):
	if constant_track is track_type and constant_track == track_type.PACKAGE: 
		return
	match body.get_groups()[0]:
		"Player": 
				assign_body_as_target(body,track_type.PLAYER)
		"Packages": 
			if body.in_air:
				assign_body_as_target(body,track_type.PACKAGE)
	
func _on_awareness_radius_body_exited(body : Node3D):
	if body.is_in_group("Player") or body.is_in_group("Packages"):
		if body == target_node:
			constant_track = false
			target_node = null
#endregion

#region Hurt

#endregion
