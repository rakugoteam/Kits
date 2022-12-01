extends Control

var menu_names:Dictionary = {
	"history":"History",
	"save":"Save",
	"load":"Load",
	"preferences":"Preferences",
	"about":"About",
	"help":"Help"
}

func _on_show_menu(menu, game_started):
	prints("opening menu:", menu, "game_started:", game_started)
	for nb in get_tree().get_nodes_in_group("nav_button"):
		$CurrentSubMenu.visible = menu in menu_names
		if menu in menu_names:
			if nb.text == menu_names[menu]:
				$CurrentSubMenu.text = menu_names[menu]
				nb.pressed = true

		if "main_menu" in nb.get_groups():
			nb.visible = !game_started
			prints("show", nb.name, "because game not started")

		if "pause_menu" in nb.get_groups():
			nb.visible = game_started
			prints("hide", nb.name, "because game is started")

