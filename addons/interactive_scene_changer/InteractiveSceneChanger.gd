# InteractiveSceneChanger, use as AutoLoaded script: MIT License
# @author Vladimir Petrenko
extends Node

signal progress_changed(progress)
signal load_done

const _load_screen_path_const = "res://addons/interactive_scene_changer_example/LoadScreen.tscn"
var _load_screen: PackedScene = preload(_load_screen_path_const)
var _load_screen_path = _load_screen_path_const
var _load_scene_resource: PackedScene
var _scene_path

var _start_time: int

var loader: ResourceInteractiveLoader
var time_max = 10000 # msec

var change_scene_immediately = true setget set_change_scene_immediately, get_change_scene_immediately

func set_change_scene_immediately(value):
	change_scene_immediately = value

func get_change_scene_immediately():
	return change_scene_immediately

func load_scene(scene_path: String, load_screen_path: String = "") -> void:
	_scene_path = scene_path
	if load_screen_path && not load_screen_path.empty() &&  load_screen_path != _load_screen_path:
		_load_screen_path = load_screen_path
		_load_screen = load(_load_screen_path)
	assert(get_tree().change_scene_to(_load_screen) == OK)

func start_load() -> void:
	_start_time = OS.get_ticks_msec()
	loader = ResourceLoader.load_interactive(_scene_path)
	if loader == null:
		push_warning("InteractiveSceneChanger => ResourceInteractiveLoader is null")
		return
	set_process(true)

func _process(time):
	if loader == null:
		set_process(false)
		return

	if OS.get_ticks_msec() > _start_time + time_max:
		push_warning(str("Loading time expired "))
		loader = null
		set_process(false)
		return

	var err = loader.poll()
	if err == ERR_FILE_EOF: # Finished loading.
		var resource = loader.get_resource()
		loader = null
		_load_scene_resource = resource
		emit_signal("progress_changed", 100.00)
		emit_signal("load_done")
		if change_scene_immediately:
			change_scene()
	elif err == OK:
		update_progress()
	else:
		assert(str("ResourceInteractiveLoader has errorindex: " + err), err != OK)
		loader = null

func change_scene() -> void:
	assert(get_tree().change_scene_to(_load_scene_resource) == OK)

func update_progress():
	var progress = float(loader.get_stage()) / loader.get_stage_count()
	progress = progress * 100.00
	emit_signal("progress_changed", progress)
