extends Node

enum Devices{
	AUTO,
	GENERIC,
	PLAYSTATION,
	NINTENDO,
	XBOX,
	KBM
}

var generic_controller_bindings : ControllerBind = load("res://resources/GenericControllerBind.tres")
var playstation_controller_bindings : ControllerBind = load("res://resources/PS5ControllerBind.tres")
