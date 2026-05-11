extends Control

@export var mainPauseMenu : PanelContainer
@export var backgroundFade : ColorRect
@export var settingsContainer : SettingsContainer

var is_paused := false

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("pause"):
		if !is_paused:
			on_pause()
		else:
			on_resume()

func on_pause():
	print("paused")
	
	is_paused = true
	get_tree().paused = true
	self.visible = true
	
	mainPauseMenu.visible = true
	backgroundFade.visible = true

func on_resume():
	is_paused = false
	get_tree().paused = false
	self.visible = false
	
	mainPauseMenu.visible = false
	backgroundFade.visible = false
	settingsContainer.reset()

func on_game_close():
	get_tree().quit()

func show_settings():
	mainPauseMenu.hide()
	settingsContainer.reset()
	settingsContainer.show()

func hide_settings():
	settingsContainer.hide()
	settingsContainer.reset()
	mainPauseMenu.show()
	pass
