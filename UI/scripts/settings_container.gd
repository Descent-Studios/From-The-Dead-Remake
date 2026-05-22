class_name SettingsContainer extends PanelContainer

@export var tabContainer : TabContainer

signal on_settings_exit

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		_on_back_button_pressed()


func reset():
	tabContainer.current_tab = 0
	self.visible = false


func _on_back_button_pressed() -> void:
	on_settings_exit.emit()
	pass # Replace with function body.
