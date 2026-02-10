extends Node
class_name PowerUp

@export var powerup_resource : PowerUp_Resource

func _on_pickup_collision_body_entered(body : Player):
	if body: #which it should be...
		print_debug("Sending powerup data to player")
		var powerup_consumed : bool = await body.add_powerup(powerup_resource)
		if powerup_consumed:
			self.queue_free()
			
	pass # Replace with function body.
