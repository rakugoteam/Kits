extends Control

signal delete_save(name)
signal select_save(name, page_index)
signal set_screenshot(screenshot)
signal set_data_time(data_time)
signal set_save_name(save_name)
signal set_delete_button(visibility)

var file := File.new()
var save_name: String = ""
var save_page_index: Vector2 = Vector2.ZERO
var screenshot: ImageTexture = null
var file_name: String = ""


func get_save_name(name: String, page_index: Vector2) -> String:
	var page_index_str := "%s_%s" % [page_index.x, page_index.y]
	var save_dir = Rakugo.store_manager.save_folder_path.plus_file(page_index_str)
	var dir = Directory.new()

	if dir.open(Rakugo.store_manager.save_folder_path) == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()

		while file_name != "":
			if !dir.current_is_dir():
				if file_name.begins_with(page_index_str):
					return file_name

			file_name = dir.get_next()

	else:
		push_error("Can't open save folder")

	return name


func init(name: String, page_index: Vector2, hide_delete: bool = false, empty: bool = false):
	if empty:
		save_name = name

	else:
		save_name = get_save_name(name, page_index)

	save_page_index = page_index
	var save_folder = Rakugo.store_manager.save_folder_path

	if !empty:
		file_name = save_name
		if page_index:
			file_name = "%s_%s_%s" % [str(save_page_index.x), str(save_page_index.y), save_name]
			var png_path = save_folder.plus_file(file_name).plus_file("screenshot.png")

			if file.file_exists(png_path):
				Rakugo.debug("slot exist, loading image")
				set_screenshot(load_screenshot_texture(png_path))

		if hide_delete:
			hide_delete_button()

	set_save_name(save_name)

	$Button/VBoxContainer/Panel/DummySlot.visible = empty
	$Button/VBoxContainer/DateLabel.visible = !empty

	var mod_time := 0
	if !empty:
		mod_time = file.get_modified_time(save_folder.plus_file(file_name).plus_file("save.json"))

	set_data_time(mod_time)


func load_screenshot_texture(path):
	var image_file = File.new()
	image_file.open(path, File.READ)

	var image = Image.new()
	image.load_png_from_buffer(image_file.get_buffer(image_file.get_len()))

	image_file.close()
	image.lock()

	var output = ImageTexture.new()
	output.create_from_image(image)
	return output


func _on_save_select():
	emit_signal("select_save", save_name, save_page_index)
	prints("select save", save_name, save_page_index)


func _on_save_delete():
	if save_page_index:
		emit_signal(
			"delete_save", "%s_%s_%s" % [str(save_page_index.x), str(save_page_index.y), save_name]
		)
	else:
		emit_signal("delete_save", save_name)


func set_screenshot(texture):
	self.screenshot = texture
	$Button/VBoxContainer/Panel/ScreenshotRect.texture = texture


func set_data_time(data_time: int):
	if data_time == 0:
		return

	var date_str := Time.get_date_string_from_unix_time(data_time)
	var time_str := Time.get_time_string_from_unix_time(data_time)
	$Button/VBoxContainer/DateLabel.text = "%s %s" % [date_str, time_str]


func set_save_name(save_name: String):
	$Button/VBoxContainer/SaveNameLabel.text = save_name


func hide_delete_button():
	emit_signal("set_delete_button", false)
