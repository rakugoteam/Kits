extends StaticBody2D
class_name StaticAdventureCharacter2D, "res://addons/adventure-kit/icons/character.svg"

export var character_tag := "tag"
export var character_name := "Name"
export var character_text_color := Color.white

onready var dialog_panel := $CharacterDialoguePanel

signal start_talking
signal end_talking

var is_talking := false setget , _get_talking
var _talking := false

func _ready():
	dialog_panel.character_tag = character_tag
	dialog_panel.character_text_color = character_text_color

	if !Rakugo.has_character(character_tag):
		Rakugo.define_character(character_tag, character_name)
		Rakugo.set_character_variable(character_tag, "text_color", character_text_color)
	
	Rakugo.connect("say", self, "_on_say")

func _on_say(character:Dictionary, text:String):
	if character_tag == character["tag"]:
		if not _talking:
			_talking = true
			emit_signal("start_talking")

	elif _talking:
		_talking = false
		emit_signal("end_talking")

func _get_talking():
	return _talking
