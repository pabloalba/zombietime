extends ColorRect

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func _on_continue_pressed():
	get_tree().change_scene("res://SelectHero.tscn")


func _on_options_pressed():
	pass # replace with function body


func _on_new_game_pressed():
	globals.savegame.current_level = 0
	get_tree().change_scene("res://SelectHero.tscn")
