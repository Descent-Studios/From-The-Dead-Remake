extends Resource
class_name ControllerBind

@export_category("Face buttons")
@export var button_0 : Texture
@export var button_1 : Texture
@export var button_2 : Texture
@export var button_3 : Texture

@export_category("Shoulder buttons")
##button 4
@export var left_shoulder : Texture
##button 5
@export var right_shoulder : Texture
##button 6
@export var left_trigger : Texture
##button 7
@export var right_trigger : Texture

@export_category("Menu buttons")
##button 8
@export var select_button : Texture
##button 9
@export var start_button : Texture

@export_category("Stick buttons")
##button 10
@export var left_stick : Texture
##button 11
@export var right_stick : Texture

@export_category("Dpad buttons")
##button 12
@export var up_button : Texture
##button 13
@export var down_button : Texture
##button 14
@export var left_button: Texture
##button 15
@export var right_button : Texture

@export_category("")
@export var default : Texture

func find_button(index : JoyButton) -> Texture:
	print(index as JoyButton)
	match index:
		JOY_BUTTON_A: return button_0
		JOY_BUTTON_B: return button_1
		JOY_BUTTON_X: return button_2
		JOY_BUTTON_Y: return button_3
		JOY_BUTTON_LEFT_SHOULDER: return left_shoulder
		JOY_BUTTON_RIGHT_SHOULDER: return right_shoulder
		#JOY_AXIS_TRIGGER_LEFT: return left_trigger
		#JOY_AXIS_TRIGGER_RIGHT: return right_trigger
		JOY_BUTTON_BACK: return select_button
		JOY_BUTTON_START: return start_button
		JOY_BUTTON_LEFT_STICK: return left_stick
		JOY_BUTTON_RIGHT_STICK: return right_stick
		JOY_BUTTON_DPAD_UP: return up_button
		JOY_BUTTON_DPAD_DOWN: return down_button
		JOY_BUTTON_DPAD_LEFT: return left_button
		JOY_BUTTON_DPAD_RIGHT: return right_button
		_: return default
