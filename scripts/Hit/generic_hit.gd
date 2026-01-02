extends Area3D

class_name GenericHitBox

@export var damage := 1
@export var can_damage := false
@export var knockback_mult := 0.0

func _ready():
	connect("area_entered", _on_area_entered)

func _on_area_entered(area : GenericHurtBox):
	if area.has_method("hit") and can_damage:
		area.hit(damage, self.global_position, knockback_mult)
