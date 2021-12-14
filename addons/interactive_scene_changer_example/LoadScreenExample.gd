# InteractiveSceneChanger, example to load big scene interactive: MIT License
# @author Vladimir Petrenko
extends Node

onready var _progress_bar: ProgressBar = $ColorRect/ProgressBar
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
	InteractiveSceneChanger.start_load()

func _on_timeout() -> void:
	_label.text = _label_texts[_text_index]
	_text_index = _text_index + 1
	if _text_index > _label_texts.size() - 1:
		_text_index = 0

func _on_progress_changed(progress) -> void:
	_progress_bar.value = progress
