extends TextureRect

var square = Vector2()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_square(x, y):
	rect_position.x = 256 * x + 155
	rect_position.y = 256 * y
	square.x = x
	square.y = y
