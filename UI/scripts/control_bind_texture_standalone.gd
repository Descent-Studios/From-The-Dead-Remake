extends TextureRect
@export var control_name : StringName
@export var current_joypad := InputManager.Devices.AUTO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if current_joypad == InputManager.Devices.AUTO:
		InputHelper.device_changed.connect(func(_d, _index): update_texture())
	update_texture()

func update_texture():
	print("aadwadwa")
	print_debug("updating texture")
	var last_used_device = InputHelper.device
	print(last_used_device)
	if last_used_device != &"keyboard":
		print("controller!")
		var joypadIndex = InputHelper.get_joypad_input_for_action(control_name).button_index
		match InputHelper.last_known_joypad_device:
			InputHelper.DEVICE_PLAYSTATION_CONTROLLER:
				current_joypad = InputManager.Devices.PLAYSTATION
				self.texture = InputManager.playstation_controller_bindings.find_button(joypadIndex)
			_: 
				current_joypad = InputManager.Devices.GENERIC
				self.texture = InputManager.generic_controller_bindings.find_button(joypadIndex)
	elif last_used_device == &"keyboard":
		print("keyboard!")
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
			self.texture = load(mouse_image_path)
		if action_type is InputEventKey:
			print_debug("updating keyboard bind")
			print_debug(action_type.keycode)
			var keycode_string := OS.get_keycode_string(action_type.keycode)
			var keycode_path : String = InputManager.keyboard_bindings_path + "keyboard_" + keycode_string.to_lower() + InputManager.keyboard_binding_type
			print_debug(keycode_path)
			self.texture = load(keycode_path)
