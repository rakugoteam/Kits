extends Slider

func _on_value_changed(value):
	Kit.auto_mode_delay = abs(value)

func _on_visibility_changed():
	if visible:
		value = -Kit.auto_mode_delay
