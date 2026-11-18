extends  Resource
class_name Saved
enum FileTypes {
	Json,
	Dat
}
##this path will be save in user:// folder unless Save in documnet was true
@export var path:String= "game_name/save"
##save as Json or dat Depndeing on your project needs
@export var type:FileTypes=FileTypes.Json
## If true a new folder in the player document will be created and saves file will be there 
@export var Save_in_Document:bool=false
