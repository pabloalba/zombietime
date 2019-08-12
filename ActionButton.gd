extends Button

var texture_enabled
var texture_disabled


func _ready():
	pass
	
func load_textures(path_enabled, path_disabled):
	var texture_enabled = load(path_enabled)
	var texture_disabled = load(path_disabled)
	
	

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func enable():
	self.icon = texture_enabled
	
func disable():
	self.icon = texture_disabled