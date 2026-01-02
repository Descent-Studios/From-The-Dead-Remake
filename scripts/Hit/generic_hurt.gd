extends Area3D
class_name GenericHurtBox

signal self_hurt

func hit(dmg, hit_pos, knockback_mult := 0.0):
	emit_signal("self_hurt",dmg, hit_pos, knockback_mult)
