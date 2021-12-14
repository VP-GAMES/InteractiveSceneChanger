# InteractiveSceneChanger, example to load big scene interactive: MIT License
# @author Vladimir Petrenko
extends Node

export(bool) var with_load_button = true

onready var _progress_bar: ProgressBar = $ColorRect/ProgressBar
onready var _button: Button = $ColorRect/Button
onready var _label: Label = $ColorRect/Label
onready var _timer: Timer = $Timer

var _text_index = 0
const _label_texts: PoolStringArray = PoolStringArray([
	"Loading     ",
	"Loading.    ",
	"Loading. .  ",
	"Loading. . .",
])

func _ready() -> void:
	_timer.connect("timeout", self, "_on_timeout")
	assert(InteractiveSceneChanger.connect("progress_changed", self, "_on_progress_changed") == OK)
	_button.hide()
	if with_load_button:
		InteractiveSceneChanger.change_scene_immediately = false
		assert(InteractiveSceneChanger.connect("load_done", self, "_on_load_done") == OK)
		_button.connect("pressed", self, "_on_button_pressed")
	InteractiveSceneChanger.start_load()

func _on_timeout() -> void:
	_label.text = _label_texts[_text_index]
	_text_index = _text_index + 1
	if _text_index > _label_texts.size() - 1:
		_text_index = 0

func _on_progress_changed(progress) -> void:
	_progress_bar.value = progress

func _on_load_done() -> void:
	print("GO")
	_button.show()

func _on_button_pressed() -> void:
	InteractiveSceneChanger.change_scene()
