tool
# Kit
extends Node

var kit_settings := {
	auto_mode_delay = "addons/kit/auto_mode_delay",
	typing_effect_delay = "addons/kit/typing_effect_delay",
	skip_delay = "addons/kit/skip_delay",
	saves_ui_page = "addons/kit/saves/current_page",
	saves_ui_pages = "addons/kit/saves/page_names",
	saves_ui_layout = "addons/kit/saves/layout",
	saves_ui_scroll = "addons/kit/saves/scroll",
	saves_ui_skip_naming = "addons/kit/saves/skip_naming",
}

var godot_settings := {
	width = "display/window/size/width",
	height = "display/window/size/height",
	fullscreen = "display/window/size/fullscreen",
	maximized = "display/window/size/maximized",
}

var audio_bus := [
	"Master",
	"BGM",
	"SFX",
	"Dialogs"
]

func _ready():
	pause_mode = PAUSE_MODE_PROCESS

func set_audio_bus(bus_name:String, volume:float, mute := false):
	var bus_id = AudioServer.get_bus_index(bus_name)
	AudioServer.set_bus_mute(bus_id, mute)
	AudioServer.set_bus_volume_db(bus_id, volume)

func get_audio_bus(bus_name:String):
	var bus_id = AudioServer.get_bus_index(bus_name)
	var mute = AudioServer.is_bus_mute(bus_id)
	var volume = AudioServer.get_bus_volume_db(bus_id)
	return {"mute":mute, "volume": volume}

func has(property:String) -> bool:
	if property in kit_settings:
		return ProjectSettings.has_setting(kit_settings[property])
	
	if property in godot_settings:
		return ProjectSettings.has_setting(godot_settings[property])
	
	return false

func _set(property:String, value) -> bool:
	if property in kit_settings:
		ProjectSettings.set_setting(kit_settings[property], value)
		return true
	
	if property in godot_settings:
		ProjectSettings.set_setting(godot_settings[property], value)
		return true
	
	return false

func _get_property_list():
	var list = []
	list.append_array(kit_settings.keys())
	list.append_array(godot_settings.keys())
	return list

func _get(property : String):
	if property in kit_settings:
		return ProjectSettings.get_setting(kit_settings[property])
	
	if property in godot_settings:
		return ProjectSettings.get_setting(godot_settings[property])
	
	return null
