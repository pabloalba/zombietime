extends TextureRect

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_title(txt):
	get_node("Title").text = txt

func set_text(txt):
	get_node("Text").text = txt

func _on_Start_pressed():
	hide()
