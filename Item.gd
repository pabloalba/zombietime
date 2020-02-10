extends Node2D

var description
var title
var power 
var durability
var weapon_range
var type
var subtype
var num

var parent

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func _on_Button_pressed():	
	parent.item_pressed(self)
	
func initialize(item_num):
	print(item_num)	
	get_node("Button").set_button_icon(globals.items_available[item_num]["texture"])	
	num = item_num
	title = globals.items_available[item_num]["title"]
	description = globals.items_available[item_num]["description"]
	power = globals.items_available[item_num]["power"]
	durability = globals.items_available[item_num]["durability"]
	weapon_range = globals.items_available[item_num]["weapon_range"]
	type = globals.items_available[item_num]["type"]
	subtype = globals.items_available[item_num]["subtype"]
	draw_metadata()	
	
	
func draw_metadata():
	if type == globals.TYPE_WEAPON:
		get_node("Pow").show()
		get_node("PowLabel").set_text(str(power))
		get_node("PowLabel").show()
		if weapon_range > 1:
			get_node("Range").show()
			get_node("RangeLabel").set_text(str(weapon_range))
			get_node("RangeLabel").show()
		if subtype == globals.SUBTYPE_BLADE:
			get_node("Durability").set_texture(globals.texture_blade[durability])
		elif subtype == globals.SUBTYPE_BLUNT:
			get_node("Durability").set_texture(globals.texture_blunt[durability])
		elif subtype == globals.SUBTYPE_BULLET:
			get_node("Durability").set_texture(globals.texture_bullet[durability])
		get_node("Durability").show()		
	elif type == globals.TYPE_ARMOR:	
		get_node("Durability").set_texture(globals.texture_shield[durability])
		get_node("Durability").show()	
