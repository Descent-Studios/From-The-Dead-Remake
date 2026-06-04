extends HBoxContainer

#@export var keybind_button : Button
#@export var controlbind_button : Button
@onready var keybind_button := $Keybind
@onready var controlbind_button := $Controlbind
@export  var keybind_disable := false 
@export  var controller_disable := false 


@export var control_name : StringName

@export var rebind_gui : ColorRect

@export var current_joypad : = InputManager.Devices.GENERIC

var is_cancelling := false
var cancel_duration := 1.0 #in seconds
var cancel_progress := 0.0
 
func _ready():
	if keybind_disable : keybind_button.set_disabled(true)
	if controller_disable : controlbind_button.set_disabled(true)
	
	InputHelper.joypad_input_changed.connect(func(_a, _button_index): update_texture())
	InputHelper.keyboard_input_changed.connect(func(_a, _key): update_texture())
	
	if current_joypad == InputManager.Devices.AUTO:
		InputHelper.device_changed.connect(func(_d, _index): update_texture())
	update_texture()

func remap_control():
	rebind_gui.show()
	rebind_gui.grab_focus()
	rebind_gui.gui_input.connect(on_gui_input)

func close_remap():
	rebind_gui.hide()
	rebind_gui.gui_input.disconnect(on_gui_input)
	update_texture()

func _process(delta: float) -> void:
	if is_cancelling: 
		cancel_progress += delta/cancel_duration
		print(cancel_progress)
		if cancel_progress >= 1.0:
			print("cancelling remap")
			close_remap()
			keybind_button.grab_focus()
			is_cancelling = false
			cancel_progress = 0.0
	
	pass

func on_gui_input(event: InputEvent) -> void:
	get_viewport().set_input_as_handled()
	
	if event.is_action_pressed("ui_cancel"):
		print("trying to cancel...")
		is_cancelling = true
	if event.is_action_released("ui_cancel"):
		print("not cancelling!")
		is_cancelling = false
		cancel_progress = 0.0
	
	if is_cancelling:
		return
	
	if (event is InputEventKey or event is InputEventMouseButton) and !keybind_disable:
		InputHelper.set_keyboard_input_for_action(control_name, event)
		close_remap()
		keybind_button.grab_focus()
		print_debug("rebound!")
	if event is InputEventJoypadButton and !controller_disable:
		InputHelper.set_joypad_input_for_action(control_name, event)
		close_remap()
		controlbind_button.grab_focus()
		print_debug("rebound!")

func update_texture():
	print_debug("updating texture")
	if keybind_button == null or controlbind_button == null:
		update_texture().call_deferred()
		return
	var joypadIndex = InputHelper.get_joypad_input_for_action(control_name).button_index
	match InputHelper.last_known_joypad_device:
		InputHelper.DEVICE_PLAYSTATION_CONTROLLER:
			current_joypad = InputManager.Devices.PLAYSTATION
			controlbind_button.icon = InputManager.playstation_controller_bindings.find_button(joypadIndex)
		_: 
			current_joypad = InputManager.Devices.GENERIC
			controlbind_button.icon = InputManager.generic_controller_bindings.find_button(joypadIndex)
	
	var action_type = InputMap.action_get_events(control_name)[0]
	print_debug(InputMap.action_get_events(control_name))
	if action_type is InputEventMouseButton:
		print_debug("updating mouse bind")
		var mouse_image_path := "res://textures/Kenney/Keyboard & Mouse/Vector/mouse.svg"
		match action_type.button_index:
			1: mouse_image_path = "res://textures/Kenney/Keyboard & Mouse/Vector/mouse_left.svg"
			2: mouse_image_path = "res://textures/Kenney/Keyboard & Mouse/Vector/mouse_right.svg"
			3: mouse_image_path = "res://textures/Kenney/Keyboard & Mouse/Vector/mouse_scroll.svg"
			8: mouse_image_path = "res://textures/Kenney/Keyboard & Mouse/Vector/mouse_side_back.svg"
			9: mouse_image_path = "res://textures/Kenney/Keyboard & Mouse/Vector/mouse_side_forward.svg"
		keybind_button.icon = load(mouse_image_path)
	if action_type is InputEventKey:
		print_debug("updating keyboard bind")
		print_debug(action_type.keycode)
		var keycode_string := OS.get_keycode_string(action_type.keycode)
		var keycode_path : String = InputManager.keyboard_bindings_path + "keyboard_" + keycode_string.to_lower() + InputManager.keyboard_binding_type
		print_debug(keycode_path)
		keybind_button.icon = load(keycode_path)
