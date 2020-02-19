extends TextureRect


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func select_level(num_level):
	globals.savegame.current_level = num_level - 1
	get_tree().change_scene("res://SelectHero.tscn")
	
