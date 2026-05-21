extends Control

@export var mainPauseMenu : PanelContainer
@export var backgroundFade : ColorRect
@export var settingsContainer : SettingsContainer

var is_paused := false

func _ready() -> void:
	mainPauseMenu.hide()
	settingsContainer.hide()

func _input(event: InputEvent) -> void:
	if Input.is_action_just_released("pause"):
		if !is_paused:
			on_pause()
		elif is_paused == true:
			on_resume()

func on_pause():
	print("paused")
	
	is_paused = true
	get_tree().paused = true
	self.show()
	
	mainPauseMenu.show()
	backgroundFade.show()

func on_resume():
	print("resuming...")
	
	is_paused = false
	get_tree().paused = false
	self.hide()
	
	mainPauseMenu.hide()
	backgroundFade.hide()
	settingsContainer.reset()

func on_restart() -> void:
	GameManager.transition_to_new_level(true)
	on_resume()

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
