extends Control


func _on_show_menu(menu, game_started):
	prints("opening menu:", menu, "game_started:", game_started)
	for nb in get_tree().get_nodes_in_group("nav_button"):
		$CurrentSubMenu.text = nb.text.capitalize()
		nb.pressed = nb.toggle_mode

		if "main_menu" in nb.get_groups():
			nb.visible = !game_started
			prints("show", nb.name, "because game not started")

		if "pause_menu" in nb.get_groups():
			nb.visible = game_started
			prints("hide", nb.name, "because game is started")

