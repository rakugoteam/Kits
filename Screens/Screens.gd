extends Control

signal show_main_menu_confirm()

const page_action_index:= {
	'history':2,
	'save':4,
	'load':4,
	'preferences':3,
	'main_menu':0,
	'about':1,
	'help':1,
	'return':0,
}

const buttons:= {
	'history':'%History',
	'save':'%Save',
	'load':'%Load',
	'preferences':'%Preferences',
	'about':'%About',
	'help':'%Help',
}

func _ready():
	get_tree().set_auto_accept_quit(false)
	Rakugo.connect("game_ended", self, "_on_game_end")
	connect("visibility_changed", self, "_on_visibility_changed")
	get_tree().paused = true

func menu_action(action):
	match action:
		"start":
			Window.select_ui_tab(1)
			Rakugo.start()

		"continue":
			if !Rakugo.loadfile("auto"):
				return
			else:
				Window.select_ui_tab(1)

		"save":
			save_menu(get_screenshot())

		"load":
			load_menu()

		"main_menu":
			if Rakugo.started:
				emit_signal("show_main_menu_confirm")
			else:
				show_page(action)

		"return":
			if Rakugo.started:
				Window.select_ui_tab(1)
			else:
				show_page(action)

		"quit":
			Window.QuitScreen.show()

		_:
			show_page(action)

func show_page(action):
	$"%CurrentSubMenu".show()
	$"%CurrentSubMenu".text = action.capitalize()

	if action in page_action_index:
		$SubMenus.current_tab = page_action_index[action]
		Window.select_ui_tab(0)

	if action in buttons:
		var b := get_node(buttons[action]) as Button
		if !b.pressed:
			b.pressed = true

func save_menu(screenshot):
	$SubMenus/SavesSlotScreen.save_mode = true
	# $SubMenus/SavesSlotScreen.screenshot = screenshot
	show_page("save")

func load_menu():
	$SubMenus/SavesSlotScreen.save_mode = false
	show_page("load")

func _on_game_end():
	Window.select_ui_tab(0)

func get_screenshot():
	var screenshot:Image = get_tree().get_root().get_texture().get_data()
	screenshot.flip_y()
	return screenshot

func _screenshot_on_input(event):
	if !event.is_action_pressed("rakugo_screenshot"):
		return

	var dir = Directory.new()
	var screenshots_dir = "user://screenshots"

	if !dir.dir_exists(screenshots_dir):
		dir.make_dir(screenshots_dir)

	var datetime = OS.get_datetime()
	var s = "{day}-{month}-{year}_{hour}-{minute}-{second}.png".format(datetime)
	get_screenshot().save_png(screenshots_dir.plus_file(s))

func _input(event):
	if visible:
		if event.is_action_pressed("ui_cancel"):
			menu_action("return")

func _on_visibility_changed():
	get_tree().paused = visible
	for nav_button in get_tree().get_nodes_in_group("nav_button"):
		if "pause_menu" in nav_button.get_groups():
			nav_button.visible = Rakugo.started
		
		if "main_menu" in nav_button.get_groups():
			nav_button.visible = !Rakugo.started

func _on_Start():
	menu_action("start")

func _on_Continue():
	menu_action("continue")

func _on_History(button_pressed:bool):
	if button_pressed:
		menu_action("history")

func _on_Save(button_pressed:bool):
	if button_pressed:
		menu_action("save")

func _on_Load(button_pressed:bool):
	if button_pressed:
		menu_action("load")

func _on_Preferences(button_pressed:bool):
	if button_pressed:
		menu_action("preferences")

func _on_MainMenu():
	menu_action("main_menu")

func _on_About(button_pressed:bool):
	if button_pressed:
		menu_action("about")

func _on_Help(button_pressed:bool):
	if button_pressed:
		menu_action("help")

func _on_Quit():
	menu_action("quit")




















