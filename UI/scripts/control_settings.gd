extends HBoxContainer

#@export var keybind_button : Button
#@export var controlbind_button : Button
@onready var keybind_button := $Keybind
@onready var controlbind_button := $Controlbind


@export var control_name : InputEventAction

@export var rebind_gui : ColorRect

@export var current_joypad : = InputManager.Devices.GENERIC

 
func _ready():
	InputHelper.joypad_input_changed.connect(func(_a, _button_index): update_texture())
	InputHelper.keyboard_input_changed.connect(func(_a, _key): update_texture())
	
	if current_joypad == InputManager.Devices.AUTO:
		InputHelper.device_changed.connect(func(_d, _index): update_texture())

func remap_control():
	rebind_gui.show()
	rebind_gui.grab_focus()
	rebind_gui.gui_input.connect(on_gui_input)

func on_gui_input(event: InputEvent) -> void:
	get_viewport().set_input_as_handled()
	#TODO Add some sort of cancellation, either ESC or hold down B / O for a few seconds...
	if (event is InputEventKey or event is InputEventMouseButton) and event.is_pressed() :
		InputHelper.set_keyboard_input_for_action(control_name.action, event)
		rebind_gui.hide()
		rebind_gui.gui_input.disconnect(on_gui_input)
		update_texture()
		keybind_button.grab_focus()
		print("rebound!")
	if event is InputEventJoypadButton and event.is_pressed():
		InputHelper.set_joypad_input_for_action(control_name.action, event)
		rebind_gui.hide()
		rebind_gui.gui_input.disconnect(on_gui_input)
		update_texture()
		controlbind_button.grab_focus()
		print("rebound!")

func update_texture():
	print("updating texture")
	if keybind_button == null or controlbind_button == null:
		update_texture().call_deferred()
		return
	var joypadIndex = InputHelper.get_joypad_input_for_action(control_name.action).button_index
	match InputHelper.last_known_joypad_device:
		InputHelper.DEVICE_PLAYSTATION_CONTROLLER:
			current_joypad = InputManager.Devices.PLAYSTATION
			controlbind_button.icon = InputManager.playstation_controller_bindings.find_button(joypadIndex)
		_: 
			current_joypad = InputManager.Devices.GENERIC
			controlbind_button.icon = InputManager.generic_controller_bindings.find_button(joypadIndex)
	
	var action_type = InputMap.action_get_events(control_name.action)[0]
	if action_type is InputEventMouseButton:
		var mouse_image_path := "res://textures/Kenney/Keyboard & Mouse/Vector/mouse.svg"
		match action_type.button_index:
			1: mouse_image_path = "res://textures/Kenney/Keyboard & Mouse/Vector/mouse_left.svg"
			2: mouse_image_path = "res://textures/Kenney/Keyboard & Mouse/Vector/mouse_right.svg"
			3: mouse_image_path = "res://textures/Kenney/Keyboard & Mouse/Vector/mouse_scroll.svg"
			8: mouse_image_path = "res://textures/Kenney/Keyboard & Mouse/Vector/mouse_side_back.svg"
			9: mouse_image_path = "res://textures/Kenney/Keyboard & Mouse/Vector/mouse_side_forward.svg"
		keybind_button.icon = load(mouse_image_path)
	elif action_type is InputEventKey:
		var key_bound = InputHelper.get_keyboard_input_for_action(control_name.action).key_label
		var keycode_string := OS.get_keycode_string(key_bound)
		var keycode_path : String = InputManager.keyboard_bindings_path + "keyboard_" + keycode_string.to_lower() + InputManager.keyboard_binding_type
		keybind_button.icon = load(keycode_path)
