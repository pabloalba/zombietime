extends Node2D

var story_title = "Chapter 3"
var story_text = """
Ok, this neigborhood is overwhelmed with zombies.
I need to go out of here, fast.

I've located a car, but it is empty. I need to
find three gas cans, and reach the car with them.
"""

var victory_title = "Chapter 1: Victory!"
var victory_text = """
There's 106 miles to Chicago,
I've got a full tank of gas, 
half a pack of chips, 
it's dark out, 
and Iḿ'm wearing sunglasses.

Hit it. 
"""

var victory_condition = {
	"position": Vector2(5, 0),
	"items": []
}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
