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

func find_button(index : int) -> Texture:
	match index:
		0: return button_0
		1: return button_1
		2: return button_2
		3: return button_3
		4: return left_shoulder
		5: return right_shoulder
		6: return left_trigger
		7: return right_trigger
		8: return select_button
		9: return start_button
		10: return left_stick
		11: return right_stick
		12: return up_button
		13: return down_button
		14: return left_button
		15: return right_button
		_: return default
