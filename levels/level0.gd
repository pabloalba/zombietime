extends Node2D

var story_title = "CHAPTER 1"
var story_text = """
The world went crazy three weeks ago.
Nobody belived it at first, but it was true.
Zombies, like in the movies, were
roaming free.

I've been hidden at home from the start, 
but Iḿ'm out of food. 
I need to think about leaving...
Wait! What is that sound? Oh, no! They have
broken the door! The zombies are here!

[color=red]IT'S ZOMBIE TIME![/color]

[color=green]OBJETIVE: Go outside[/color]
"""

var victory_title = "Chapter 0: Victory!"
var victory_text = """

[center]Ok, Iḿ'm alive... for now.[/center]
"""

var victory_condition = {
	"position": Vector2(2, 1),
	"items": []
}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

