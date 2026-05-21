extends Control

@export var default_color : Color
@export var hidden_color : Color

func _ready() -> void:
	SignalBus.loading_level_start.connect(on_start_loading)
	SignalBus.level_transition_hide.connect(on_start_loading)
	SignalBus.level_transition_show.connect(on_end_loading)
	pass

func on_start_loading(_var):
	print("hiding screen")
	self.show()
	$AnimationPlayer.play("transition_start")
	await $AnimationPlayer.animation_finished
	SignalBus.level_transition_finish.emit()

func on_end_loading():
	print("showing screen")
	$AnimationPlayer.queue("transition_end")
	await $AnimationPlayer.animation_finished
	self.hide()
	SignalBus.level_transition_finish.emit()
