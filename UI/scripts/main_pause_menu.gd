extends PanelContainer

signal on_resume
signal on_settings
signal on_exit

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_resume_button_pressed() -> void:
	on_resume.emit()
	pass # Replace with function body.


func _on_settings_button_pressed() -> void:
	on_settings.emit()
	pass # Replace with function body.


func _on_exit_button_pressed() -> void:
	on_exit.emit()
	pass # Replace with function body.
