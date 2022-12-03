extends VBoxContainer

export(PackedScene) var HistoryItem: PackedScene

var current_menu := []
var current_ask := {
	"character": {},
	"question": "",
	"answer": ""
}

func _ready() -> void:
	connect("visibility_changed", self, "_on_visibility_changed")
	Rakugo.connect("say", self, "_on_say")
	Rakugo.connect("ask", self, "_on_ask")
	Rakugo.connect("ask_return", self, "_on_answer_return")
	Rakugo.connect("menu", self, "_on_menu")
	Rakugo.connect("menu_return", self, "_on_menu_return")

func get_history() -> Array:
	if !Rakugo.has_variable("_history"):
		Rakugo.set_variable("_history", [])
	
	return Rakugo.get_variable("_history")

func add_to_history(type:String, character:Dictionary, text:String, extra:={}) -> void:
	var history = get_history()
	history.append({
		"type": type,
		"character": character,
		"text": text
	}.merge(extra))
	Rakugo.set_variable("_history", history)

func _on_say(character:Dictionary, text:String) -> void:
	add_to_history("say", character, text)

func _on_ask(character:Dictionary, question:String, default_answer:String) -> void:
	current_ask["character"] = character
	current_ask["question"] = question
	current_ask["answer"] = default_answer

func _on_answer_return(answer:String) -> void:
	current_ask["answer"] = answer
	add_to_history(
		"ask", 
		current_ask["character"],
		current_ask["question"],
		{"answer":answer}
	)

func _on_menu(choices:Array) -> void:
	current_menu = choices

func _on_menu_return(index:int) -> void:
	add_to_history("menu", {}, current_menu[index])

func _on_visibility_changed() -> void:
	if not visible:
		return
	
	for c in self.get_children():
		remove_child(c)
	
	var new_item:Control = null
	var history = Rakugo.get_variable("_history")
	
	for item in history:
		new_item = HistoryItem.instance()
		new_item.setup(item)
		add_child(new_item)
	get_parent().call_deferred('scroll_to_bottom')
