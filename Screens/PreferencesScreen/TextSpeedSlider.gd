extends Slider

func _on_value_changed(value):
	ProjectSettings.set_setting(Kit.typing_effect_delay, abs(value))

func _on_visibility_changed():
	if visible and ProjectSettings.has_setting(Kit.typing_effect_delay):
		value = -ProjectSettings.get_setting(Kit.typing_effect_delay)
