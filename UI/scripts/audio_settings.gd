extends HBoxContainer

enum audioBuses{
	Master,
	SFX
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var masterVolume = db_to_linear(AudioServer.get_bus_volume_db(audioBuses.Master))
	$"Audio Controls/Master/volumeSlider".value = masterVolume
	$"Audio Controls/Master/volumeSlider/#".text = ("%d%%" % (masterVolume*100))
	var sfxVolume = db_to_linear(AudioServer.get_bus_volume_db(audioBuses.SFX))
	$"Audio Controls/SFx/volumeSlider".value = sfxVolume
	$"Audio Controls/SFx/volumeSlider/#".text = ("%d%%" % (sfxVolume*100))
	pass # Replace with function body.


func change_volume(amt : float, bus : int) -> void:
	AudioServer.set_bus_volume_db(bus,linear_to_db(amt))
	pass

func _on_master_volume_slider_value_changed(value: float) -> void:
	change_volume(value,audioBuses.Master)
	$"Audio Controls/Master/volumeSlider/#".text = ("%d%%" % (value*100))
	pass # Replace with function body.


func _on_sfx_volume_slider_value_changed(value: float) -> void:
	change_volume(value,audioBuses.SFX)
	$"Audio Controls/SFx/volumeSlider/#".text = ("%d%%" % (value*100))
	pass # Replace with function body.
