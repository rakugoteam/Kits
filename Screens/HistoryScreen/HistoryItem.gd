extends PanelContainer

func setup(history_item:Dictionary) -> void:
	var type = history_item.get("type", "")
	if !type:
		push_warning("History item has no type: %s" % history_item)
		return
	
	var label = $DialogLabel
	label.markup_text = ""
	# print ("setting history item:", history_item)
	if type in ["say", "ask"]:
		var character = history_item.get("character", {})

		if character.empty():
			character = Rakugo.get_narrator()
		
		# print("character:", character)
		var ch_name = character.get("name", "")
		var text = history_item.get("text", "")
		
		label.markup_text = "# %s \n%s" % [ch_name, text]

	if type == "ask":
		var answer = history_item.get("answer", "")
		if !answer:
			push_warning("Ask History item has no answer: %s" % history_item)
		label.markup_text += "\n*Answer*: `%s`" % history_item["answer"]
	
	if type == "menu":
		var text = history_item.get("text", "")
		if !text:
			push_warning("Menu History item has no text: %s" % history_item)
		label.markup_text = "*Chosen*: %s" % history_item["text"]



