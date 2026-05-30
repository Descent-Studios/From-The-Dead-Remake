extends Control

@export var mainPauseMenu : PanelContainer
@export var backgroundFade : ColorRect
@export var settingsContainer : SettingsContainer

var is_paused := false

var settings_shown := false

func _ready() -> void:
	mainPauseMenu.hide()
	settingsContainer.hide()

func _input(event: InputEvent) -> void:
	#if Input.is_action_just_released("pause"):
	if event.is_action_released("pause"):
		if !is_paused:
			on_pause()
		elif is_paused == true:
			on_resume()
	if event.is_action_pressed("ui_close_dialog") and !settings_shown and is_paused:
		on_resume()

func on_pause():
	print("paused")
	
	is_paused = true
	get_tree().paused = true
	self.show()
	
	mainPauseMenu.show()
	backgroundFade.show()
	
	$mainPauseMenu/HBoxContainer/VBoxContainer/ReusmeButton.grab_focus()

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
	
	settings_shown = true
	$settingsContainer/TabContainer.get_tab_bar().grab_focus()

func hide_settings():
	settingsContainer.hide()
	settingsContainer.reset()
	mainPauseMenu.show()
	
	settings_shown = false
	$mainPauseMenu/HBoxContainer/VBoxContainer/ReusmeButton.grab_focus()
