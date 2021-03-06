extends TextureRect

var main_scene
var current_item_pos
var current_item
var current_weapon
var current_armor
signal inventory_screen_closed






var inventory = [null, null, null, null, null, null,null, null, null, null, null, null]

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func empty():
	current_weapon = null
	current_armor = null
	for item in inventory:
		if item != null:
			remove_child(item)
	inventory = [null, null, null, null, null, null,null, null, null, null, null, null]


#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func create_item(item_num):
	var item_instance = load("res://Item.tscn").instance()
	item_instance.initialize(item_num)
	item_instance.parent = self
	return item_instance
	
	
func add_item(item_num):
	var item = create_item(item_num)	
	if add_item_to_inventory(item):
		add_child(item)	
		return item
		
func add_item_to_inventory(item):
	var pos = inventory.find(null)	
	if pos > -1:
		inventory[pos] = item
		item.position.x = 223 + (((pos % 3)) * 134)
		item.position.y = 100 + (( pos / 3) * 134)
		return true
	else:
		return false
	
func item_pressed(item):
	get_node("Equip").show()
	get_node("Discard").show()
	get_node("Title").set_text(item.title)
	get_node("Description").set_text(item.description)
	current_item = item
	
	if item == current_weapon or item == current_armor:
		get_node("Equip").set_text("Unequip")
		current_item_pos = -1
		
	else:
		get_node("Equip").set_text("Equip")
		current_item_pos = inventory.find(item)		
		
	for i in inventory:
		if i != null:
			i.get_node("Button").set_flat(true)
			
	if current_weapon:
		current_weapon.get_node("Button").set_flat(true)
		
	if current_armor:
		current_armor.get_node("Button").set_flat(true)
		
		
	item.get_node("Button").set_flat(false)
	
func clear_item():
	get_node("Equip").hide()
	get_node("Discard").hide()
	get_node("Title").set_text("")
	get_node("Description").set_text("")
	for i in inventory:
		if i != null:
			i.get_node("Button").set_flat(true)

func _on_Button_pressed():	
	hide()
	emit_signal("inventory_screen_closed")


func _on_Discard_pressed():
	if current_item:		
		if current_item_pos > -1:
			inventory[current_item_pos] = null						
		remove_child(current_item)
		if current_weapon == current_item:			
			current_weapon = null
			main_scene.update_weapon(null)
		if current_armor == current_item:			
			current_armor = null
			main_scene.update_armor(null)
		current_item = null
		current_item_pos = -1
		clear_item()
		


func _on_Equip_pressed():
	if current_item:
		if current_item == current_weapon:
			unequip_weapon()
		elif current_item == current_armor:
			unequip_armor()
		else:
			if current_item_pos > -1:
				if current_item["type"] == globals.TYPE_WEAPON:
					equip_weapon()
				elif current_item["type"] == globals.TYPE_ARMOR:
					equip_armor()


func equip_weapon():		
	inventory[current_item_pos] = null
	
	if current_weapon:
		add_item_to_inventory(current_weapon)
		
	current_weapon = current_item
	current_item_pos = -1
	current_weapon.position.x = 732
	current_weapon.position.y = 513
	
	get_node("Equip").set_text("Unequip")
	
	main_scene.update_weapon(current_weapon)
	
func unequip_weapon():
	if add_item_to_inventory(current_weapon):
		current_weapon = null
		main_scene.update_weapon(null)
		item_pressed(current_item)
		
		
func equip_armor():
	inventory[current_item_pos] = null
	
	if current_armor:
		add_item_to_inventory(current_armor)
		
	current_armor = current_item
	current_item_pos = -1
	current_armor.position.x = 932
	current_armor.position.y = 513
	
	get_node("Equip").set_text("Unequip")
	
	main_scene.update_armor(current_armor)
	
	
func unequip_armor():
	if add_item_to_inventory(current_armor):
		current_armor = null
		main_scene.update_armor(null)
		item_pressed(current_item)
	
func update_weapon_durability():
	if current_weapon:
		if current_weapon.durability > 1:
			current_weapon.durability -= 1
			if current_item == current_weapon:
				current_item.draw_metadata()			
		else:
			remove_child(current_weapon)
			if current_item == current_weapon:
				current_item = null
				clear_item()
			current_weapon = null
			
		main_scene.update_weapon(current_weapon)
			
func update_armor_durability(num):
	if current_armor:
		current_armor.durability -= num
		if current_armor.durability > 0:
			main_scene.update_armor(current_armor)
			if current_item == current_armor:
				current_item.draw_metadata()
			return 0
			
		else:
			var remaining = - current_armor.durability
			remove_child(current_armor)
			if current_item == current_armor:
				current_item = null
				clear_item()
			current_armor = null
			main_scene.update_armor(null)
			return remaining
	else:
		return num

func to_map():
	var data = {
		"current_weapon": null,
		"current_armor": null,
		"inventory": []
	}
	if current_armor:
		data.current_armor = {
			"num": current_armor.num,
			"durability": current_armor.durability
		}
	if current_weapon:
		data.current_weapon = {
			"num": current_weapon.num,
			"durability": current_weapon.durability
		}
	for item in inventory:
		if item:
			data.inventory.append({
				"num": item.num,
				"durability": item.durability
			})
	return data
	
func from_map(data):	
	empty()
	if data:
		var item
		if data.current_armor:
			item = add_item(data.current_armor.num)
			item.durability = data.current_armor.durability
			current_item = item
			current_item_pos = 0
			item.draw_metadata()
			equip_armor()
			
		if data.current_weapon:
			item = add_item(data.current_weapon.num)
			item.durability = data.current_weapon.durability
			current_item = item
			current_item_pos = 0
			item.draw_metadata()
			equip_weapon()
			
		for i in data.inventory:
			item = add_item(i.num)			
			item.durability = i.durability
			item.draw_metadata()
		
	
