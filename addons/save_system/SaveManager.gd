extends Node

var SAVE_DIRECTORY := ""
var SAVE_TYPE
var is_doc := false

signal saved(export_data: Dictionary)
signal loaded_save_file(incoming_data: Dictionary)

var save_data := {}
var current_save_slot: int = 0

var system_path = OS.get_system_dir(OS.SYSTEM_DIR_DOCUMENTS)

const SETTINGS = preload("uid://bnjhkxeli6bla")


func load_settings() -> void:
	SAVE_DIRECTORY = str(SETTINGS.path)
	SAVE_TYPE = SETTINGS.type
	is_doc = SETTINGS.Save_in_Document


func _get_clean_subpath() -> String:
	var cleaned := SAVE_DIRECTORY.strip_edges()
	if cleaned.begins_with("user://"):
		cleaned = cleaned.substr("user://".length())
	return cleaned.strip_edges().trim_prefix("/").trim_suffix("/")


func get_save_folder() -> String:
	var sub := _get_clean_subpath()
	if is_doc:
		return system_path.path_join(sub) if sub != "" else system_path
	return "user://".path_join(sub) if sub != "" else "user://"


func get_save_path(file_name: String) -> String:
	return get_save_folder().path_join(file_name)


func get_save_files() -> Array[String]:
	load_settings()
	var file_data_list: Array = []
	var folder := get_save_folder()
	var ext := ".json" if SAVE_TYPE == SETTINGS.FileTypes.Json else ".dat"

	if DirAccess.dir_exists_absolute(folder):
		var all_files := DirAccess.get_files_at(folder)
		for file_name in all_files:
			if file_name.ends_with(ext):
				var full_file_path := folder.path_join(file_name)
				var modified_time := FileAccess.get_modified_time(full_file_path)
				file_data_list.append({
					"path": file_name.get_basename(),
					"time": modified_time
				})
		file_data_list.sort_custom(func(a, b): return a["time"] > b["time"])
	else:
		print("Directory does not exist: ", folder)

	var sorted_paths: Array[String] = []
	for item in file_data_list:
		sorted_paths.append(item["path"])

	return sorted_paths


func add_to_save(data: Dictionary) -> bool:
	save_data.merge(data, true)
	return true


func load_item(data: String) -> Dictionary:
	if !save_data.has(data):
		return {}
	return save_data[data]


func get_sav_data():
	return save_data


func save_game(file_name: String) -> bool:
	load_settings()
	var folder := get_save_folder()
	if not is_doc and folder != "user://":
		DirAccess.make_dir_recursive_absolute(folder)
	elif is_doc:
		DirAccess.make_dir_recursive_absolute(folder)

	saved.emit(save_data)

	if SAVE_TYPE == SETTINGS.FileTypes.Json:
		var file_path := get_save_path(file_name + ".json")
		var file := FileAccess.open(file_path, FileAccess.WRITE)
		if file == null:
			push_error("Could not open save file for writing: " + file_path)
			return false

		file.store_string(JSON.stringify(save_data, "\t"))
		file.close()
		return true
	else:
		var file_path := get_save_path(file_name + ".dat")
		var file := FileAccess.open(file_path, FileAccess.WRITE)
		if file == null:
			push_error("Could not open save file for writing: " + file_path)
			return false

		file.store_var(save_data)
		file.close()
		return true


func load_game(file_name: String) -> bool:
	load_settings()

	if SAVE_TYPE == SETTINGS.FileTypes.Json:
		var file_path := get_save_path(file_name + ".json")
		if !FileAccess.file_exists(file_path):
			return false

		var file := FileAccess.open(file_path, FileAccess.READ)
		if file == null:
			push_error("Could not open save file: " + file_path)
			return false

		var json_text := file.get_as_text()
		file.close()

		var json := JSON.new()
		if json.parse(json_text) != OK:
			push_error("Could not parse save file: " + file_path)
			return false

		if typeof(json.data) != TYPE_DICTIONARY:
			push_error("Invalid save data.")
			return false

		save_data = json.data
		loaded_save_file.emit(save_data)
		return true
	else:
		var file_path := get_save_path(file_name + ".dat")
		if not FileAccess.file_exists(file_path):
			return false

		var file := FileAccess.open(file_path, FileAccess.READ)
		if file == null:
			push_error("Could not open save file: " + file_path)
			return false

		var incoming_data = file.get_var()
		file.close()

		if typeof(incoming_data) != TYPE_DICTIONARY:
			push_error("Invalid save data.")
			return false

		save_data = incoming_data
		loaded_save_file.emit(save_data)
		return true


func save_exists(file_name: String) -> bool:
	load_settings()
	var ext := ".json" if SAVE_TYPE == SETTINGS.FileTypes.Json else ".dat"
	return FileAccess.file_exists(get_save_path(file_name + ext))


func delete_save(file_name: String) -> bool:
	load_settings()
	var ext := ".json" if SAVE_TYPE == SETTINGS.FileTypes.Json else ".dat"
	var file_path := get_save_path(file_name + ext)
	if !FileAccess.file_exists(file_path):
		print("not there")
		return false

	return DirAccess.remove_absolute(file_path) == OK
