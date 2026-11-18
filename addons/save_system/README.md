# Godot Save Manager

A simple and flexible **Save Manager for Godot 4**.

This tool provides an easy way to save, load, list, check, and delete game save files. It supports **JSON** and **Godot binary `.dat`** files and allows saves to be stored either in Godot's `user://` directory or the user's **Documents** folder.

The Save Manager is designed to work as an **Autoload/Singleton**, making it accessible throughout your project.

---

## Features

* Save and load game data
* Supports **JSON** and **Godot binary `.dat`** files
* Multiple save files / save slots
* Save files can be stored in:

  * `user://`
  * The user's Documents folder
* Automatically creates the save directory
* List existing save files
* Sort saves by modification date
* Check if a save exists
* Delete save files
* Signals for save and load events
* Allows individual game systems to manage their own save data

---

# Installation

Add the Save Manager files to your Godot project.

For example:

```text
res://addons/save_manager/
├── save_manager.gd
├── settings.gd
└── README.md
```

Add the Save Manager as an **Autoload**:

**Project → Project Settings → Globals → Autoload**

For example:

```text
Name: SaveManager
Path: res://addons/save_manager/save_manager.gd
```

You can then access it anywhere in your project:

```gdscript
SaveManager.save_game("slot_1")
```

---

# Save Location

The Save Manager supports two save locations.

### User Data

When Documents saving is disabled:

```text
user://SAVE_DIRECTORY/
```

For example:

```text
user://MyGame/Saves/
```

### Documents

When Documents saving is enabled, the manager uses the user's Documents folder:

```text
Documents/SAVE_DIRECTORY/
```

For example:

```text
Documents/MyGame/Saves/
```

This is useful when you want players to easily access, back up, or transfer their save files.

---

# Save File Types

The Save Manager supports two file formats.

## JSON

JSON files use:

```text
.json
```

Example:

```json
{
    "player": {
        "money": 500,
        "level": 5
    }
}
```

JSON is useful when you want save files to be human-readable and easy to inspect.

---

## Godot Binary

Godot's built-in serialization can be used instead:

```text
.dat
```

The manager uses:

```gdscript
file.store_var(save_data)
```

and:

```gdscript
file.get_var()
```

Binary saves are generally more compact and convenient for storing Godot data, but they are not human-readable.

---

# Basic Usage

## Add Data

Add data to the current save:

```gdscript
SaveManager.add_to_save({
    "player": {
        "money": 500,
        "level": 5
    }
})
```

You can add data from multiple systems:

```gdscript
SaveManager.add_to_save({
    "player": player_data
})

SaveManager.add_to_save({
    "inventory": inventory_data
})

SaveManager.add_to_save({
    "farm": farm_data
})
```

---

## Save

Save the current data:

```gdscript
SaveManager.save_game("slot_1")
```

The manager automatically uses the configured file type.

For JSON:

```text
slot_1.json
```

For binary:

```text
slot_1.dat
```

---

## Load

Load a save:

```gdscript
if SaveManager.load_game("slot_1"):
    print("Game loaded!")
else:
    print("Save not found.")
```

---

## Get Data

Get the complete save Dictionary:

```gdscript
var data = SaveManager.get_sav_data()
```

Or get a specific section:

```gdscript
var player_data = SaveManager.load_item("player")
```

If the requested item does not exist, an empty Dictionary is returned.

---

# Save and Load Signals

The Save Manager provides two signals:

```gdscript
signal saved(export_data: Dictionary)
signal loaded_save_file(incoming_data: Dictionary)
```

These signals allow individual game objects or systems to handle their own save and load data.

For example, a player can connect to both signals:

```gdscript
func _ready() -> void:
    SaveManager.loaded_save_file.connect(_on_data_loaded)
    SaveManager.saved.connect(_on_data_saved)
```

When the game is saved, the player can add its data:

```gdscript
func _on_data_saved(export_data: Dictionary) -> void:
    var data = {
        "player_data": {
            "pos": {
                "x": global_position.x,
                "y": global_position.y
            },
            "facing": current_direction
        }
    }

    export_data.merge(data, true)
```

When the game is loaded, the player can retrieve its data:

```gdscript
func _on_data_loaded(incoming_data: Dictionary) -> void:
    if incoming_data.has("player_data"):
        var data = incoming_data["player_data"]

        global_position.x = float(data["pos"]["x"])
        global_position.y = float(data["pos"]["y"])

        current_direction = data["facing"]
```

This allows different systems to manage their own data.

For example:

```text
Player       → player_data
Inventory    → inventory_data
Farm         → farm_data
NPCs         → npc_data
Settings     → settings_data
```

The Save Manager handles the save file, while each system handles the data it needs to save or load.

---

# Save Exists

Check whether a save file exists:

```gdscript
if SaveManager.save_exists("slot_1"):
    print("Save exists!")
```

The manager automatically checks the configured file type.

---

# Get Save Files

Get a list of all existing saves:

```gdscript
var saves = SaveManager.get_save_files()
```

The returned value is:

```gdscript
Array[String]
```

Example:

```text
[
    "slot_1",
    "slot_2",
    "autosave"
]
```

The file extension is removed from the returned names.

Save files are sorted by modification time, with the most recently modified save first.

This can be useful for creating a save/load menu.

---

# Delete a Save

Delete a save file:

```gdscript
if SaveManager.delete_save("slot_1"):
    print("Save deleted!")
```

The manager automatically determines whether the file is:

```text
slot_1.json
```

or:

```text
slot_1.dat
```

based on the configured save type.

---

# Multiple Save Slots

There is no fixed number of save slots.

You can create as many save files as needed:

```gdscript
SaveManager.save_game("slot_1")
SaveManager.save_game("slot_2")
SaveManager.save_game("slot_3")
```

You can also use custom names:

```gdscript
SaveManager.save_game("farm_01")
SaveManager.save_game("farm_02")
```

This can also be used for special saves:

```gdscript
SaveManager.save_game("autosave")
SaveManager.save_game("quicksave")
```

---

# Example

A simple save/load system could look like this:

```gdscript
# Add data
SaveManager.add_to_save({
    "player": {
        "money": 1000,
        "level": 10
    }
})

# Save
SaveManager.save_game("slot_1")

# Check if save exists
if SaveManager.save_exists("slot_1"):
    print("Save found!")

# Load
SaveManager.load_game("slot_1")

# Get player data
var player_data = SaveManager.load_item("player")
```

---

# API

| Function                   | Description                          |
| -------------------------- | ------------------------------------ |
| `load_settings()`          | Loads the Save Manager settings      |
| `get_save_path(file_name)` | Returns the full path to a save file |
| `get_save_folder()`        | Returns the save directory           |
| `get_save_files()`         | Returns all available save files     |
| `add_to_save(data)`        | Adds data to the current save        |
| `load_item(data)`          | Gets a specific section of save data |
| `get_sav_data()`           | Gets the complete save Dictionary    |
| `save_game(file_name)`     | Saves the current game data          |
| `load_game(file_name)`     | Loads a save file                    |
| `save_exists(file_name)`   | Checks if a save exists              |
| `delete_save(file_name)`   | Deletes a save file                  |

---

# Recommended Save Structure

For larger games, organize your save data into separate sections.

For example:

```gdscript
{
    "player_data": {},
    "inventory_data": {},
    "farm_data": {},
    "npc_data": {},
    "world_data": {},
    "settings_data": {}
}
```

This makes it easier for individual systems to find and manage their own data.

---

# Save Versioning

For larger projects, consider adding a save version:

```gdscript
SaveManager.add_to_save({
    "save_version": 1,
    "player_data": player_data
})
```

Save versions can be used later to migrate older save files when your game's save structure changes.

---

# Important Notes

### Save Data Is Not Secure

Neither JSON nor `.dat` files should be considered secure or tamper-proof.

Players can potentially modify their save files.

If your game requires protection against save editing, consider adding encryption, validation, checksums, or other integrity checks.

### Clear Data for a New Game

If starting a completely new game, clear the existing save data before adding the new game's data:

```gdscript
SaveManager.save_data.clear()
```

---

# Requirements

* Godot 4.x
* GDScript

---

# License

Add your preferred license here.

Example:

```text
MIT License
```

---

# Author

Created as a reusable save system for **Godot 4** projects.
