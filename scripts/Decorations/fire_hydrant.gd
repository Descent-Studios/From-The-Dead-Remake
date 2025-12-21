extends Node3D
class_name destroyable


@export var anim_player : AnimationPlayer
@export var health := 10

func _on_col_checker_body_entered(_body):
	if health > 1 : 
		health -= 1
		return
	if health == 1:
		health = 0
		anim_player.play("hydrant explode")
	pass # Replace with function body.
