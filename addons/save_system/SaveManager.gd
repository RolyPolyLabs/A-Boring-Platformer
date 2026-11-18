extends Node


var SAVE_DIRECTORY :=""
var SAVE_TYPE
var is_doc:=false
signal saved(export_data: Dictionary)
signal loaded_save_file(incoming_data: Dictionary)

var save_data := {}
var current_save_slot: int = 0

var system_path=OS.get_system_dir(OS.SYSTEM_DIR_DOCUMENTS)

const SETTINGS = preload("uid://bnjhkxeli6bla")

func load_settings() -> void:
	SAVE_DIRECTORY=SETTINGS.path
	SAVE_TYPE=SETTINGS.type
	is_doc=SETTINGS.Save_in_Document
	pass
	
	
	
func get_save_path(file_name:String) -> String:
	var path=""
	if is_doc:
		path=system_path+"/" +SAVE_DIRECTORY + "/" + file_name
	else: 
		path="user://"+SAVE_DIRECTORY + "/" + file_name

	return path
	
func get_save_folder()-> String:
	var path=""
	if is_doc:
		path=system_path+"/" +SAVE_DIRECTORY 
	else: 
		path="user://"+SAVE_DIRECTORY 
	return path

func get_save_files() -> Array[String]:
	load_settings()
	var file_data_list: Array = []
	var path=get_save_folder()
	var type:=""
	if SAVE_TYPE==SETTINGS.FileTypes.Json:
		type=".json"
	else:
		type=".dat"
	if DirAccess.dir_exists_absolute(path):
		var all_files = DirAccess.get_files_at(path)
		for file in all_files:
			if file.ends_with(type):
				var modified_time=FileAccess.get_modified_time(path+"/"+file)
				file_data_list.append({
					"path": file.get_basename(),
					"time": modified_time
				})
		file_data_list.sort_custom(func(a, b): return a["time"] > b["time"])
	else:
		print("Directory does not exist: ", path)
	
	var sorted_paths: Array[String] = []
	for item in file_data_list:
		sorted_paths.append(item["path"])
		
	return sorted_paths
	
func add_to_save(data:Dictionary)->bool:
	save_data.merge(data)
	return true

func load_item(data:String)->Dictionary:
	if !save_data.has(data):
		return {}
	return save_data[data]
	
func get_sav_data():
	return save_data
	
func save_game(file_name:String) -> bool:
	load_settings()
	var path=""
	if is_doc:
		path=system_path+"/"+SAVE_DIRECTORY  
	else: 
		path="user://"+SAVE_DIRECTORY
	DirAccess.make_dir_recursive_absolute(path)
	


	saved.emit(save_data)
	
	if SAVE_TYPE==SETTINGS.FileTypes.Json:
		var file := FileAccess.open(get_save_path(file_name+".json"), FileAccess.WRITE)

		if file == null:
			push_error("Could not open save file for writing.")
			return false

		file.store_string(JSON.stringify(save_data, "\t"))
		file.close()
		
		return true
	else:
		var file := FileAccess.open(get_save_path(file_name+".dat"), FileAccess.WRITE)

		if file == null:
			push_error("Could not open save file for writing: " + path)
			return false

		# Godot binary serialization
		file.store_var(save_data)
		file.close()

		return true


func load_game(file_name:String) -> bool:
	load_settings()
	
	if SAVE_TYPE==SETTINGS.FileTypes.Json:

		var path := get_save_path(file_name+".json")

		if !FileAccess.file_exists(path):
			return false

		var file := FileAccess.open(path, FileAccess.READ)
		
		if file == null:
			push_error("Could not open save file.")
			return false

		var json_text := file.get_as_text()
		file.close()

		var json := JSON.new()

		if json.parse(json_text) != OK:
			push_error("Could not parse save file.")
			return false

		save_data = json.data

		if typeof(save_data) != TYPE_DICTIONARY:
			push_error("Invalid save data.")
			return false
		loaded_save_file.emit(save_data)
		loaded_save_file.emit()
		return true
	else:
		var path := get_save_path(file_name+".dat")

		if not FileAccess.file_exists(path):
			return false

		var file := FileAccess.open(path, FileAccess.READ)
		
		if file == null:
			push_error("Could not open save file: " + path)
			return false

		var incoming_data = file.get_var()
		file.close()

		if typeof(incoming_data) != TYPE_DICTIONARY:
			push_error("Invalid save data.")
			return false

		save_data = incoming_data
		
		loaded_save_file.emit(save_data)

		return true

	
	
func save_exists(file_name:String) -> bool:
	var type:=""
	if SAVE_TYPE==SETTINGS.FileTypes.Json:
		type=".json"
	else:
		type=".dat"
	return FileAccess.file_exists(get_save_path(file_name+type))


func delete_save(file_name:String) -> bool:
	var type:=""
	if SAVE_TYPE==SETTINGS.FileTypes.Json:
		type=".json"
	else:
		type=".dat"
	var path := get_save_path(file_name+type)
	if !FileAccess.file_exists(path):
		print("not there")
		return false

	return DirAccess.remove_absolute(path) == OK
