extends Area3D
class_name GenericHurtBox

signal self_hurt

func hit(dmg, hit_pos):
	emit_signal("self_hurt",dmg, hit_pos)
