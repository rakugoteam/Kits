extends Panel

signal show_menu(menu, game_started)
signal nav_button_press(nav_action)

func _ready():
	connect_buttons()
	_show_menu("main_menu", Rakugo.started)

func disable_continue_button():
	var auto_save_path : String = Rakugo.store_manager.\
		save_folder_path.plus_file("auto").plus_file("save.json")
	if not File.new().file_exists(auto_save_path):
		for n in get_tree().get_nodes_in_group("continue"):
			n.disabled = true

func _show_menu(menu, game_started):
	emit_signal("show_menu", menu, game_started)

func connect_buttons():
	for nb in get_tree().get_nodes_in_group("nav_button"):
		nb.connect("nav_button_pressed", self, "_on_nav_button_pressed")
	
func _on_nav_button_pressed(nav_action):
	if nav_action != "quit":
		_show_menu(nav_action, Rakugo.started)

	emit_signal("nav_button_press", nav_action)
