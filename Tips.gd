extends TextureRect
signal tip_closed

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func set_info(text, texture):
	get_node("Text1").text = text
	get_node("IconContainer/Icon").texture = texture
	
	
func _on_Ok_pressed():
	emit_signal("tip_closed")
	hide()
