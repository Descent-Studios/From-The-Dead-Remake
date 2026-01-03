extends Node3D
class_name destroyable


@export var anim_player : AnimationPlayer
@export var health := 10

func _on_col_checker_self_hurt(dmg, hit_pos, knockback_mult := 0.0):
	if health > 1 : 
		health -= dmg
		return
	if health == 1:
		health = 0
		anim_player.play("hydrant explode")
