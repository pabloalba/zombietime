
extends Node2D

var story_title = "Chapter 2"
var story_text = """
I'm lost. Somehow I reached a dead end
on a residencial neigborhood.

And it is overwhelmed with zombies.
I need to go out of here, fast.




[color=green]OBJETIVE: Reach the far end of the street[/color]

"""

var victory_title = "Chapter 1: Victory!"
var victory_text = """
I hate suburbs. 
I hate suburbs full of zombies.
But I hate suburbs full of soccer-mums-zombies above all.
"""

var victory_condition = {
	"position": Vector2(12, 2),
	"items": []
}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
