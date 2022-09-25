extends KinematicBody2D
class_name AdventureCharacter2D, "res://addons/adventure-kit/icons/walk.svg"

export var character_tag := "tag"
export var character_name := "Name"
export var character_text_color := Color.white
export var speed := 100.0 setget _set_speed, _get_speed
export var input_disabled := false setget _set_input_disabled, _get_input_disabled
onready var _agent := $NavigationAgent2D as NavigationAgent2D
onready var dialog_panel := $CharacterDialoguePanel

var _velocity := Vector2.ZERO
var walk_ended := true

var is_talking := false setget , _get_talking
var _talking := false

signal walk(direction, speed)
signal walk_end
signal start_talking
signal end_talking

func _ready():
	add_to_group("characters")
	dialog_panel.character_tag = character_tag
	dialog_panel.character_text_color = character_text_color

	if !Rakugo.character_exists(character_tag):
		Rakugo.define_character(character_tag, character_name)
		Rakugo.set_character_variable(character_tag, "text_color", character_text_color)
	
	Rakugo.connect("say", self, "_on_say")

func _set_input_disabled(disabled: bool):
	set_process_input(!disabled)
	_agent.avoidance_enabled = !disabled

func _get_input_disabled() -> bool:
	return !is_processing_input()

func walk_to(location: Vector2):
	_agent.set_target_location(location)

func _set_speed(value: float):
	_agent.max_speed = value

func _get_speed() -> float:
	return _agent.max_speed

func _process(delta):
	if Input.is_action_just_pressed("left_click"):
		var mouse_pos := get_global_mouse_position()
		walk_ended = false
		walk_to(mouse_pos)
		return

func _physics_process(delta: float) -> void:
	if _agent.is_navigation_finished():
		if !walk_ended:
			walk_ended = true
			emit_signal("walk_end")
		return

	var target_global_position := _agent.get_next_location()
	var direction := global_position.direction_to(target_global_position)
	var desired_velocity := direction * _agent.max_speed
	_velocity += (desired_velocity - _velocity) * delta * 8.0
	_agent.set_velocity(_velocity)
	move_and_collide(_velocity * delta)
	emit_signal("walk", direction, _agent.max_speed)

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
