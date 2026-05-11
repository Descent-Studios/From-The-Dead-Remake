class_name SettingsContainer extends PanelContainer

@export var tabContainer : TabContainer

signal on_settings_exit


func reset():
	tabContainer.current_tab = 0
	self.visible = false


func _on_back_button_pressed() -> void:
	on_settings_exit.emit()
	pass # Replace with function body.
