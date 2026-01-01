extends Area3D

class_name GenericHitBox

@export var Damage := 1


func _ready():
	connect("area_entered", _on_area_entered)

func _on_area_entered(area : GenericHurtBox):
	area.hit(Damage, self.global_position)
