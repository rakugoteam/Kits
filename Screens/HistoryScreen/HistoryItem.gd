extends PanelContainer

onready var label := $DialogLabel

func setup(history_item:Dictionary) -> void:
	var type = history_item["type"]
	if type in ["say", "ask"]:
		var character = history_item["character"] 
		if character.empty():
			character = Rakugo.get_narrator()
		
		var ch_name = character.get("name", "null")
		var text = history_item["text"]
		label.markup_text = "# %s \n%s" % [ch_name, text]

	if type == "ask":
		label.markup_text += "\n*Answer:* `%s`" % history_item["answer"]
	
	if type == "menu":
		label.markup_text += "\n*Chosen: %s" % history_item["text"]



