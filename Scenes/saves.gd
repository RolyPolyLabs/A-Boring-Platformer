extends Control

signal save_requested(save_name: String)
signal load_requested(save_name: String)

@export var saves_dir: String = "user://saves"
@export var save_extension: String = ".json"

@onready var save_dropdown: OptionButton = $VBoxContainer/OptionButton
@onready var new_save_input: LineEdit = $VBoxContainer/LineEdit
@onready var save_button: Button = $VBoxContainer/Save
@onready var load_button: Button = $VBoxContainer/Load
@onready var delete_button: Button = $VBoxContainer/Delete
@onready var export_button: Button = $VBoxContainer/Export
@onready var file_dialog: FileDialog = $FileDialog
@onready var save_popup: AcceptDialog = $SavePopup
@onready var overwrite_popup: ConfirmationDialog = $OverwritePopup

var _pending_save_name: String = ""
var _pending_export_save_name: String = ""


func _ready() -> void:
	if save_button and not save_button.pressed.is_connected(_on_save_pressed):
		save_button.pressed.connect(_on_save_pressed)
	if load_button and not load_button.pressed.is_connected(_on_load_pressed):
		load_button.pressed.connect(_on_load_pressed)
	if delete_button and not delete_button.pressed.is_connected(_on_delete_pressed):
		delete_button.pressed.connect(_on_delete_pressed)
	if export_button and not export_button.pressed.is_connected(_on_export_pressed):
		export_button.pressed.connect(_on_export_pressed)

	if file_dialog:
		file_dialog.file_mode = FileDialog.FILE_MODE_SAVE_FILE
		if not file_dialog.file_selected.is_connected(_on_export_file_selected):
			file_dialog.file_selected.connect(_on_export_file_selected)

	if overwrite_popup:
		overwrite_popup.title = "Overwrite Save?"
		overwrite_popup.ok_button_text = "Yes"
		overwrite_popup.cancel_button_text = "No"
		if not overwrite_popup.confirmed.is_connected(_on_overwrite_confirmed):
			overwrite_popup.confirmed.connect(_on_overwrite_confirmed)
		if not overwrite_popup.canceled.is_connected(_on_overwrite_canceled):
			overwrite_popup.canceled.connect(_on_overwrite_canceled)

	refresh_save_list()


func refresh_save_list() -> void:
	if not save_dropdown:
		return

	var current_selection := _get_selected_save_name()
	save_dropdown.clear()

	var dir := DirAccess.open(saves_dir)
	if dir:
		dir.list_dir_begin()
		var file_name := dir.get_next()
		while file_name != "":
			if not dir.current_is_dir() and file_name.ends_with(save_extension):
				save_dropdown.add_item(file_name.get_basename())
			file_name = dir.get_next()
		dir.list_dir_end()

	if current_selection != "":
		_select_save_by_name(current_selection)


func _get_selected_save_name() -> String:
	if not save_dropdown or save_dropdown.item_count == 0 or save_dropdown.selected < 0:
		return ""
	return save_dropdown.get_item_text(save_dropdown.selected)


func _select_save_by_name(save_name: String) -> void:
	if not save_dropdown:
		return
	for i in range(save_dropdown.item_count):
		if save_dropdown.get_item_text(i) == save_name:
			save_dropdown.select(i)
			return


func _get_save_file_path(save_name: String) -> String:
	return saves_dir.path_join(save_name + save_extension)


func _save_exists(save_name: String) -> bool:
	return FileAccess.file_exists(_get_save_file_path(save_name))


func _sync_signal_bus_to_save_data() -> void:
	var sav_data: Dictionary = SaveManager.get_sav_data()
	sav_data["signal_bus"] = {
		"score": SignalBus.score,
		"skin": SignalBus.skin,
		"hasmap": SignalBus.hasmap,
		"HasBootBadge": SignalBus.HasBootBadge,
		"HasJumpBadge": SignalBus.HasJumpBadge,
		"HasHeartBadge": SignalBus.HasHeartBadge,
		"HasFlashBadge": SignalBus.HasFlashBadge,
		"HasBreadBadge": SignalBus.HasBreadBadge,
	}


func _format_bus_summary(prefix_line: String) -> String:
	var bus_data: Dictionary = SaveManager.get_sav_data().get("signal_bus", {})
	return (
		prefix_line + "\n"
		+ "Score: %s\n" % str(int(bus_data.get("score", SignalBus.score)))
		+ "Skin: %s\n" % str(bus_data.get("skin", SignalBus.skin))
		+ "Map: %s\n" % str(bus_data.get("hasmap", SignalBus.hasmap))
		+ "Boot Badge: %s\n" % str(bus_data.get("HasBootBadge", SignalBus.HasBootBadge))
		+ "Jump Badge: %s\n" % str(bus_data.get("HasJumpBadge", SignalBus.HasJumpBadge))
		+ "Heart Badge: %s\n" % str(bus_data.get("HasHeartBadge", SignalBus.HasHeartBadge))
		+ "Flash Badge: %s\n" % str(bus_data.get("HasFlashBadge", SignalBus.HasFlashBadge))
		+ "Bread Badge: %s" % str(bus_data.get("HasBreadBadge", SignalBus.HasBreadBadge))
	)


func _show_popup(popup_title: String, message: String) -> void:
	if not save_popup:
		return
	save_popup.title = popup_title
	save_popup.dialog_text = message
	save_popup.popup_centered()


func _on_save_pressed() -> void:
	var typed_name := new_save_input.text.strip_edges() if new_save_input else ""
	var target_name := typed_name if typed_name != "" else _get_selected_save_name()
	if target_name == "":
		target_name = "save_1"

	if _save_exists(target_name) and overwrite_popup:
		_pending_save_name = target_name
		overwrite_popup.dialog_text = "A save named '%s' already exists. Do you want to overwrite it?" % target_name
		overwrite_popup.popup_centered()
		return

	_perform_save(target_name)


func _on_overwrite_confirmed() -> void:
	var target_name := _pending_save_name
	_pending_save_name = ""
	if target_name != "":
		_perform_save(target_name)


func _on_overwrite_canceled() -> void:
	_pending_save_name = ""


func _perform_save(target_name: String) -> void:
	_sync_signal_bus_to_save_data()
	var saved_ok := SaveManager.save_game(target_name)

	if new_save_input:
		new_save_input.text = ""
	refresh_save_list()
	_select_save_by_name(target_name)
	save_requested.emit(target_name)

	if saved_ok:
		_show_popup("Saved", _format_bus_summary("Saved to slot: %s" % target_name))
	else:
		_show_popup("Save Failed", "Could not save to slot: " + target_name)


func _on_load_pressed() -> void:
	var save_name := _get_selected_save_name()
	if save_name == "":
		return

	var loaded_ok: Variant = SaveManager.load_game(save_name)
	load_requested.emit(save_name)

	var was_loaded := true if loaded_ok == null else bool(loaded_ok)
	if was_loaded:
		_show_popup("Loaded", _format_bus_summary("Loaded slot: %s" % save_name))
	else:
		_show_popup("Load Failed", "Could not load slot: " + save_name)


func _on_delete_pressed() -> void:
	var save_name := _get_selected_save_name()
	if save_name == "":
		return

	var file_path := _get_save_file_path(save_name)
	if not FileAccess.file_exists(file_path):
		_show_popup("Delete Failed", "Save file not found for slot: " + save_name)
		return

	var err := DirAccess.remove_absolute(ProjectSettings.globalize_path(file_path))
	refresh_save_list()

	if err == OK:
		_show_popup("Deleted", "Deleted save slot: " + save_name)
	else:
		_show_popup("Delete Failed", "Could not delete save slot: " + save_name)


func _on_export_pressed() -> void:
	var save_name := _get_selected_save_name()
	if save_name == "":
		return

	var source_path := _get_save_file_path(save_name)
	if not FileAccess.file_exists(source_path):
		_show_popup("Export Failed", "Save file not found for slot: " + save_name)
		return

	_pending_export_save_name = save_name
	if file_dialog:
		file_dialog.current_file = save_name + save_extension
		file_dialog.popup_centered()


func _on_export_file_selected(dest_path: String) -> void:
	if _pending_export_save_name == "":
		return

	var source_path := _get_save_file_path(_pending_export_save_name)
	_pending_export_save_name = ""

	var source_file := FileAccess.open(source_path, FileAccess.READ)
	if not source_file:
		_show_popup("Export Failed", "Could not read source save file.")
		return

	var content := source_file.get_as_text()
	source_file.close()

	var dest_file := FileAccess.open(dest_path, FileAccess.WRITE)
	if not dest_file:
		_show_popup("Export Failed", "Could not write export file to:\n" + dest_path)
		return

	dest_file.store_string(content)
	dest_file.close()

	_show_popup("Exported", "Exported save to:\n" + dest_path)
