extends HBoxContainer

@export var keybind_button : Button
@export var controlbind_button : Button

@export var control_name : InputEventAction

@export var rebind_gui : ColorRect

@export var current_joypad : = InputManager.Devices.GENERIC

 
func _ready():
	InputHelper.joypad_input_changed.connect(func(_a, _button_index): update_texture())
	#InputHelper.joypad_changed.connect(update_texture)
	
	if current_joypad == InputManager.Devices.AUTO:
		InputHelper.device_changed.connect(func(_d, _index): update_texture())

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
		self.grab_focus()
		print("rebound!")
	if event is InputEventJoypadButton and event.is_pressed():
		InputHelper.set_joypad_input_for_action(control_name.action, event)
		rebind_gui.hide()
		rebind_gui.gui_input.disconnect(on_gui_input)
		self.grab_focus()
		print("rebound!")

func update_texture():
	print("updating texture")
	if keybind_button == null or controlbind_button == null:
		update_texture().call_deferred()
		return
	var joypadIndex = InputHelper.get_joypad_input_for_action(control_name.action).button_index
	print(joypadIndex)
	match InputHelper.last_known_joypad_device:
		InputHelper.DEVICE_PLAYSTATION_CONTROLLER:
			current_joypad = InputManager.Devices.PLAYSTATION
			controlbind_button.icon = InputManager.playstation_controller_bindings.find_button(joypadIndex)
		_: 
			current_joypad = InputManager.Devices.GENERIC
			controlbind_button.icon = InputManager.generic_controller_bindings.find_button(joypadIndex)
			
