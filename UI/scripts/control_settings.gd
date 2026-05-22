extends HBoxContainer


@export var keybind_button : Button
@export var mousebind_button : Button
@export var controlbind_button : Button

@export var control_name : InputEventAction

@export var rebind_gui : ColorRect

var inputs : Array[InputEvent]
 
func _ready():
	inputs = InputMap.action_get_events(control_name.action)
	#rebind_gui.connect(gui_input,on_gui_input)
	
func remap_control():
	rebind_gui.show()
	rebind_gui.grab_focus()
	rebind_gui.gui_input.connect(on_gui_input)

func on_gui_input(event: InputEvent) -> void:
	get_viewport().set_input_as_handled()
	if (event is InputEventKey or event is InputEventMouseButton) and event.is_pressed() :
		InputHelper.set_keyboard_input_for_action(control_name.action, event)
		rebind_gui.hide()
		rebind_gui.gui_input.disconnect(on_gui_input)
		print("rebound!")
	if event is InputEventJoypadButton and event.is_pressed():
		InputHelper.set_joypad_input_for_action(control_name.action, event)
		rebind_gui.hide()
		rebind_gui.gui_input.disconnect(on_gui_input)
		print("rebound!")
