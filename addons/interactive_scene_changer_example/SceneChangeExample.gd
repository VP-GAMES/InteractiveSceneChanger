# InteractiveSceneChanger, example : MIT License
# @author Vladimir Petrenko
tool
extends Spatial

export (String, FILE) var to_scene
export (NodePath) var obj_path
export (int, 0, 100000) var obj_count = 0

onready var _button: Button = $CanvasLayer/Button
onready var _duplicated: Spatial = $Duplicated

func _ready() -> void:
	assert(_button.connect("pressed", self, "_on_button_pressed") == OK)

func _on_button_pressed() -> void:
	InteractiveSceneChanger.load_scene(to_scene)

func _process(delta: float) -> void:
	if Engine.editor_hint:
		if obj_path && _duplicated:
			_check_duples_to_remove()
			_check_duples_to_add()

func _check_duples_to_remove() -> void:
	if _duplicated.get_child_count() <= obj_count:
		return
	for child in _duplicated.get_children():
		_duplicated.remove_child(child)
		child.queue_free()
		if _duplicated.get_child_count() <= obj_count:
			return

func _check_duples_to_add() -> void:
	if _duplicated.get_child_count() >= obj_count:
		return
	while _duplicated.get_child_count() < obj_count:
		var duple = get_node(obj_path).duplicate()
		_duplicated.add_child(duple)
		duple.set_owner(get_tree().edited_scene_root)
