class_name StaticBodyFloor3D extends StaticBody3D


@export var floor_type := GameManager.FLOOR_TYPES.DEFAULT

func get_floor_type() -> GameManager.FLOOR_TYPES:
	return floor_type
