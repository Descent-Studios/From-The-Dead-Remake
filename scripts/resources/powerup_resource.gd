extends Resource
class_name PowerUp_Resource

@export var time_active : float = 1.0

@export var speed_effect : float = 1.0
## Do you want the new effect value to multiply or override?
@export var speed_override : bool = false
@export var acceleration_effect : float = 1.0
## Do you want the new effect value to multiply or override?
@export var acceleration_override : bool = false
@export var deceleration_effect : float = 1.0
## Do you want the new effect value to multiply or override?
@export var deceleration_override : bool = false

@export var throw_force_multiplier : float = 1.0

@export var package_pickup_radius_multiplier : float = 1.0

@export var knockback_force_effect : float = 1.0
