extends Container
var tips_enabled = false
var map
var hero

const tiles_can_move_left = [1,2,3,4,5,6,7,8,9,10,11,12,13,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,33,35,36,37,39,40,41,43,44,45,47,48,51,52,53,57,58,68,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,97,99,100,101,103,104,105,107,108,109,111,112,115,116,117,121,122,132,145,146,147,148,149,150,151,152,153,154,155,156,157,158,159,161,163,164,165,167,168,169,171,172,173,175,176,179,180,181,185,186,196]
const tiles_can_move_right = [1,2,3,4,5,6,7,8,9,10,11,12,13,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,33,34,35,37,38,39,41,42,43,45,46,47,49,50,53,55,56,66,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,97,98,99,101,201,103,105,106,107,109,110,111,113,114,117,119,120,130,145,146,147,148,149,150,151,152,153,154,155,156,157,158,159,161,162,163,165,166,167,169,170,171,173,174,175,177,178,181,183,184,194]
const tiles_can_move_up = [1,2,3,4,5,6,7,8,9,10,11,12,13,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,33,34,36,37,38,40,41,42,44,45,46,48,49,52,54,55,58,65,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,97,98,100,101,102,104,105,106,108,109,110,112,113,116,118,119,122,129,145,146,147,148,149,150,151,152,153,154,155,156,157,158,159,161,162,164,165,166,168,169,170,172,173,174,176,177,180,182,183,186,193]
const tiles_can_move_down = [1,2,3,4,5,6,7,8,9,10,11,12,13,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,34,35,36,38,39,40,42,43,44,46,47,48,50,51,54,56,57,67,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,98,99,100,102,103,104,106,107,108,110,111,112,114,115,118,120,121,131,145,146,147,148,149,150,151,152,153,154,155,156,157,158,159,162,163,164,166,167,168,170,171,172,174,175,176,178,179,182,184,185,195]


const MODE_PLAYER_ACTION = 1
const MODE_PLAYER_ANIMATION = 2
const MODE_ZOMBIE_TIME = 3
const MODE_END = 4
const MODE_TIP = 5

const ACTION_WALK = 0
const ACTION_ATTACK = 1
const ACTION_SEARCH = 2

const UP = 0
const RIGHT = 1
const DOWN = 2
const LEFT = 3
const STAY = 4

const SPAWN_DOWN = 339
const SPAWN_RIGHT = 340
const SPAWN_UP = 341
const SPAWN_LEFT = 342


var mode = MODE_PLAYER_ACTION
var current_action = ACTION_WALK

var inventory_screen

var actions
const fist_texture = preload("res://assets/img/play/hud/weapons/fist.png")
var current_weapon = null
var current_armor = null
var current_zombie = null

var zombies = []
var spawn_points = []
var search_points = []


var is_search_action = false

var music = load("res://assets/sound/music.ogg")


var tips = {
	"movement": {
		"text": "You have three actions\nevery turn. Use your first\naction to move one square",
		"texture": preload("res://assets/img/play/hud/walk.png")
	},
	"attack": {
		"text": "Now you can use one\naction to attack and\nkill a zombie.",
		"texture": fist_texture
	},
	"noweapon": {
		"text": "Attacking a zombie without\na weapon is dangerous.\nYou have killed it,\nbut you got hurt!",
		"texture": preload("res://assets/img/play/tips/hearts.png")
	},
	"zombietime": {
		"text": "When you have done\nall three actions, it's\nZombie Time!\nThe zombies will move\nAnd hit you if they are close",
		"texture": null
	},
	"searcheable": {
		"text": "If a tile has the \"searcheable\"\n icon, you can use an action to\nsearch and find an item",
		"texture": preload("res://assets/img/play/searcheable.png")
	},
	"inventory": {
		"text": "This is the inventory screen.\nIn it you can equip, unequip and\ndiscard your weapons and armor",
		"texture": preload("res://assets/img/play/hud/inventory.png")
	},
	"armor": {
		"text": "If you receive damage with\nan armor equiped, the armor will\ntake the damage instead\nof you (until it's destroyed)",
		"texture": preload("res://assets/img/play/tips/armor.png")
	},
	"skip": {
		"text": "Sometimes it's better to\nskip an action than to end your\nturn on a dangerous position",
		"texture": preload("res://assets/img/play/hud/skip.png")
	},
	"weapon": {
		"text": "You can use a weapon a limited\nnumber of times. With some\nweapons you can attack from\nafar, and some weapons\ncan kill more than one zombie\n with one hit",
		"texture": null
	}
}

var tip = "movement"

func _ready():
	inventory_screen = get_node("HUD/InventoryScreen")
	get_node("HUD/InventoryScreen").connect("inventory_screen_closed", self, "inventory_screen_closed")
	inventory_screen.main_scene = self
		
	get_node("HUD/SearchScreen").connect("take_item", self, "take_item")
	get_node("HUD/SearchScreen").connect("discard_item", self, "discard_item")
	
	get_node("HUD/StoryScreen").connect("story_closed", self, "story_closed")
	get_node("HUD/Tips").connect("tip_closed", self, "finish_action_no_tips")
	get_node("HUD/OptionsScreen").connect("restart", self, "reset_map")
	get_node("HUD/OptionsScreen").connect("start_stop_music", self, "start_stop_music")
	
	#loop
	get_node("Music").connect("finished", self, "start_music")
	
	reset_map()
	
func reset_map():
	inventory_screen.empty()
	
	map = load("res://levels/level" + str(globals.settings.current_level) + ".tscn").instance()
	add_child(map)
	get_node("HUD/StoryScreen").set_title(map.story_title)
	get_node("HUD/StoryScreen").set_text(map.story_text)
	
	zombies = []
	spawn_points = []
	search_points = []
	
	var decoration = map.get_node("decoration")
	for tile in decoration.get_used_cells():
		var content = decoration.get_cell(tile.x, tile.y)
		if content >= 339 and content <=342:
			spawn_points.append({"square": Vector2(tile.x, tile.y), "type": content})
			
	var search = map.get_node("search")
	for tile in search.get_used_cells():
		var content = search.get_cell(tile.x, tile.y)
		var sp = add_search_point(tile.x, tile.y)
		search_points.append(sp)
	search.visible = false

	hero = get_node("Hero")
	hero.connect("melee_hit", self, "player_melee_hit")
	hero.connect("atack_end", self, "player_atack_end")
	hero.lives = globals.settings.heroes_health[globals.hero]
	update_lives()
	
	get_node("HUD/Bg/LabelName").text = globals.hero_names[globals.hero]

	var characters = map.get_node("characters")
	for tile in characters.get_used_cells():
		var content = characters.get_cell(tile.x, tile.y)
		if content == globals.TILE_HERO_START:
			hero.set_square(tile.x, tile.y)
		elif content == globals.TILE_ZOMBIE_1:
			add_zombie(tile.x, tile.y)
		elif content == globals.TILE_ZOMBIE_2:
			add_zombie(tile.x, tile.y)
			add_zombie(tile.x, tile.y)
		elif content == globals.TILE_ZOMBIE_3:
			add_zombie(tile.x, tile.y)
			add_zombie(tile.x, tile.y)
			add_zombie(tile.x, tile.y)
	join_zombies()
	characters.visible = false
	
	_on_WalkButton_pressed()
	update_weapon(null)
	update_armor(null)
	_update_search_button()
	
	
	inventory_screen.from_map(globals.settings.inventory)
	
	
	start_music()
	new_turn()
	
#	inventory_screen.add_item(globals.ITEM_GUN)
#	inventory_screen.add_item(globals.ITEM_KNIFE)
#	inventory_screen.add_item(globals.ITEM_HOCKEY)
#	inventory_screen.add_item(globals.ITEM_CROWBAR)
#	inventory_screen.add_item(globals.ITEM_RIFLE)
#	inventory_screen.add_item(globals.ITEM_RIOT_GEAR)
#	inventory_screen.add_item(globals.ITEM_HOCKEY)
#	inventory_screen.add_item(globals.ITEM_JACKET)
#	inventory_screen.add_item(globals.ITEM_GUN)
	
	
	
#warning-ignore:unused_argument
func _process(delta):
	if mode == MODE_PLAYER_ACTION:
		pass
	elif (mode == MODE_PLAYER_ANIMATION):
		if hero.position.x == hero.desired_position.x and hero.position.y == hero.desired_position.y:
			finish_action()			
	elif mode == MODE_ZOMBIE_TIME:
		if is_zombie_time_finished():
			end_zombie_time()
			
					
func finish_action():
	hero.num_actions -= 1
	if hero.num_actions == 0 and tip == null:
		set_tip("zombietime")
	get_node("HUD/Bg/LabelActions").text = str(hero.num_actions)
	_update_search_button()
	var is_end_game = check_end_game()
	if not is_end_game:
		if not check_tips():
			finish_action_no_tips()

func check_tips():	
	if tips_enabled and tip != null and not globals.settings.tips_shown.has(tip):
		var tip_info = tips[tip]
		globals.settings.tips_shown.append(tip)
		globals.save_settings()
		show_tip(tip_info["text"], tip_info["texture"])
		return true
	return false
			
func show_tip(text, texture):
	mode = MODE_TIP
	get_node("HUD/Tips").set_info(text, texture)
	get_node("HUD/Tips").show()
			
func finish_action_no_tips():
	tip = null
	if (hero.num_actions == 0):
		zombie_time()
	else:		
		mode = MODE_PLAYER_ACTION		
		_on_WalkButton_pressed()

func check_end_game():
	var is_dead = check_death()
	if is_dead:
		get_node("HUD/StoryScreen").set_title("GAME OVER")
		get_node("HUD/StoryScreen").set_text(globals.gameover_text)
		get_node("HUD/StoryScreen").show()		
		mode = MODE_END
		return true
	else:
		var is_victory = check_victory()
		if is_victory:
			get_node("HUD/StoryScreen").set_title(map.victory_title)
			get_node("HUD/StoryScreen").set_text(map.victory_text)
			get_node("HUD/StoryScreen").show()
			mode = MODE_END
			update_end_level_settings()
			return true
		else:
			return false
		
func update_end_level_settings():
	globals.settings.heroes_health[globals.hero] = hero.lives
	globals.settings.max_level += 1
	globals.settings.inventory = inventory_screen.to_map()
	globals.save_settings()
	
func check_death():
	return (hero.lives <= 0)
	
func check_victory():
	return map.victory_condition.position.x == hero.square.x and map.victory_condition.position.y == hero.square.y

func new_turn():
	mode = MODE_PLAYER_ACTION
	hero.num_actions = 3
	get_node("HUD/Bg/LabelActions").text = str(hero.num_actions)
	update_lives()
	_on_WalkButton_pressed()
	
func end_zombie_time():
	join_zombies()
	get_node("HUD/LabelZombieTime").hide()
	var is_end_game = check_end_game()
	if not is_end_game:
		new_turn()
	
func join_zombies():
	var remove_zombies = []
	for i in range(len(zombies)):
		var zombie = zombies[i]
		if zombie.num !=0 :			
			for j in range(i+1, len(zombies)):
				if zombie.square.x == zombies[j].square.x and zombie.square.y == zombies[j].square.y:					
					zombie.inc_num(zombies[j].num)					
					zombies[j].set_num(0)
					remove_zombies.append(zombies[j])
			
			
	for zombie in remove_zombies:
		kill_zombie(zombie)
		
		
			
func add_zombie(x, y):
	var zombie = load("res://Zombie.tscn").instance()
	zombie.set_square(x, y)
	zombie.main_scene = self
	add_child(zombie)
	zombies.append(zombie)	
	zombie.connect("melee_hit", self, "show_player_damage_effect")
	return zombie
	
func add_search_point(x, y):
	var search_point = load("res://SearchPoint.tscn").instance()
	search_point.set_square(x, y)
	add_child(search_point)
	return search_point
	
				
func draw_valid_squares():
	if current_action == ACTION_WALK:
		#get_node("Hero/canMoveStay").show()
		if _can_move_up(hero.square) and get_zombies(hero.square.x, hero.square.y - 1) == []:
			get_node("Hero/canMoveUp").show()
		else:
			get_node("Hero/canMoveUp").hide()
		
		if _can_move_down(hero.square) and get_zombies(hero.square.x, hero.square.y + 1) == []:
			get_node("Hero/canMoveDown").show()
		else:
			get_node("Hero/canMoveDown").hide()
			
		if _can_move_left(hero.square) and get_zombies(hero.square.x - 1, hero.square.y) == []:
			get_node("Hero/canMoveLeft").show()
		else:
			get_node("Hero/canMoveLeft").hide()
			
		if _can_move_right(hero.square) and get_zombies(hero.square.x + 1, hero.square.y) == []:
			get_node("Hero/canMoveRight").show()
		else:
			get_node("Hero/canMoveRight").hide()
		
func hide_all_squares():
	#get_node("Hero/canMoveStay").hide()
	get_node("Hero/canMoveUp").hide()
	get_node("Hero/canMoveDown").hide()
	get_node("Hero/canMoveLeft").hide()
	get_node("Hero/canMoveRight").hide()

				
func _move_hero(direction):		
	var desired_square = Vector2(hero.square.x, hero.square.y)	
	
	var can_move = false	
	if direction == LEFT and _can_move_left(hero.square) and get_zombies(hero.square.x - 1, hero.square.y) == []:
		desired_square.x = hero.square.x -1
		can_move = true
	elif direction == RIGHT and _can_move_right(hero.square) and get_zombies(hero.square.x + 1, hero.square.y) == []:
		desired_square.x = hero.square.x + 1
		can_move = true
	elif direction == UP and _can_move_up(hero.square) and get_zombies(hero.square.x, hero.square.y - 1) == []:
		desired_square.y = hero.square.y -1
		can_move = true
	elif direction == DOWN and _can_move_down(hero.square) and get_zombies(hero.square.x, hero.square.y + 1) == []:
		desired_square.y = hero.square.y + 1
		can_move = true
		
	if can_move:
		mode = MODE_PLAYER_ANIMATION
		hide_all_squares()		
		hero.set_desired_square(desired_square.x, desired_square.y)
		set_tip("attack")
		
func attack_zombie(zombie):
	if current_action == ACTION_ATTACK:	
		hero_start_attack(zombie)
		if current_weapon != null:
			set_tip("weapon")
	
func hero_start_attack(zombie):
	print("hero_start_attack", hero.num_actions, hero.mode)
	current_zombie = zombie
	if current_weapon == null or current_weapon.weapon_range == 1:
		get_node("Hero/Camera2D").current = false
		hero.melee_hit(zombie.square.x, zombie.square.y)
	else:
		damage_zombie()
		player_atack_end()
	

func kill_zombie(zombie):
	remove_child(zombie)
	zombies.erase(zombie)
	
		
func _can_move_left(vector):
	var current_tile = map.get_node("floor").get_cell(vector.x, vector.y) + 1
	var desired_tile = map.get_node("floor").get_cell(vector.x-1, vector.y) + 1	
	return current_tile in tiles_can_move_left and desired_tile in tiles_can_move_right
	
func _can_move_right(vector):
	var current_tile = map.get_node("floor").get_cell(vector.x, vector.y) + 1
	var desired_tile = map.get_node("floor").get_cell(vector.x+1, vector.y) + 1	
	return current_tile in tiles_can_move_right and desired_tile in tiles_can_move_left

func _can_move_up(vector):
	var current_tile = map.get_node("floor").get_cell(vector.x, vector.y) + 1
	var desired_tile = map.get_node("floor").get_cell(vector.x, vector.y-1) + 1	
	return current_tile in tiles_can_move_up and desired_tile in tiles_can_move_down
	
func _can_move_down(vector):
	var current_tile = map.get_node("floor").get_cell(vector.x, vector.y) + 1
	var desired_tile = map.get_node("floor").get_cell(vector.x, vector.y+1) + 1	
	return current_tile in tiles_can_move_down and desired_tile in tiles_can_move_up
	
func _update_search_button():
	var current_tile = _get_search_item()
	if current_tile == -1:
		get_node("HUD/Bg/SearchButton").set_disabled(true)
	else:
		get_node("HUD/Bg/SearchButton").set_disabled(false)
		set_tip("searcheable")
		
func _get_search_item():
	return map.get_node("search").get_cell(hero.square.x, hero.square.y)
		
func update_weapon(weapon):
	var texture = fist_texture 
	current_weapon = null
	if weapon:
		texture = weapon.get_node("Button").get_button_icon()
		current_weapon = weapon
		get_node("HUD/Bg/AttackButton/weapon").set_texture(texture)
		get_node("HUD/Bg/AttackButton/durability").set_texture(weapon.get_node("Durability").get_texture())
		get_node("HUD/Bg/AttackButton/durability").show()
		
		get_node("HUD/Bg/AttackButton/pow_label").set_text(str(weapon.power))
	else:
		get_node("HUD/Bg/AttackButton/weapon").set_texture(fist_texture)
		current_weapon = null
		get_node("HUD/Bg/AttackButton/durability").hide()
		get_node("HUD/Bg/AttackButton/pow_label").set_text("1")
		
	if current_action == ACTION_ATTACK:
		unmark_all_zombies()
		mark_valid_zombies()
		
	

func update_armor(armor):	
	print(armor)
	current_armor = armor
	get_node("HUD/Bg/ArmorContainer/Armor1").empty()
	get_node("HUD/Bg/ArmorContainer/Armor2").empty()
	get_node("HUD/Bg/ArmorContainer/Armor3").empty()
	if armor != null:		
		get_node("HUD/Bg/CurrentArmor").texture = globals.items_available[current_armor.num]["texture"]
		
		if armor.durability >= 1:
			get_node("HUD/Bg/ArmorContainer/Armor1").fill()
		if armor.durability >= 2:
			get_node("HUD/Bg/ArmorContainer/Armor2").fill()
		if armor.durability >= 3:
			get_node("HUD/Bg/ArmorContainer/Armor3").fill()
	else:
		get_node("HUD/Bg/CurrentArmor").texture = null
		
		
		

func zombie_time():
	hide_all_squares()
	unmark_all_zombies()
	get_node("HUD/LabelZombieTime").show()
		
	for spawn in spawn_points:
		spawn_zombie(spawn)
			
	for zombie in zombies:
		move_zombie(zombie)
		
	mode = MODE_ZOMBIE_TIME
		
func spawn_zombie(spawn):
	var zombie = add_zombie(spawn.square.x, spawn.square.y)
	zombie.just_spawned = true
	if spawn.type == SPAWN_DOWN:		
		zombie.position.y += 256
	elif spawn.type == SPAWN_UP:
		zombie.position.y -= 256
	elif spawn.type == SPAWN_LEFT:
		zombie.position.x -= 256
	elif spawn.type == SPAWN_RIGHT:
		zombie.position.x += 256
	
		
		
func move_zombie(zombie):
	var desired_square = Vector2(zombie.square.x, zombie.square.y)
	if zombie.just_spawned:
		zombie.just_spawned = false
	else:
		if zombie.square.x > hero.square.x and _can_move_left(zombie.square):
			desired_square = Vector2(zombie.square.x - 1, zombie.square.y)
		elif zombie.square.x < hero.square.x and _can_move_right(zombie.square):
			desired_square = Vector2(zombie.square.x + 1, zombie.square.y)
		elif zombie.square.y > hero.square.y and _can_move_up(zombie.square):
			desired_square = Vector2(zombie.square.x, zombie.square.y - 1)
		elif zombie.square.y < hero.square.y and _can_move_down(zombie.square):
			desired_square = Vector2(zombie.square.x, zombie.square.y + 1)
	
		
	if desired_square.x == hero.square.x and desired_square.y == hero.square.y:
		zombie_hit(zombie, desired_square.x, desired_square.y)
	else:
		zombie.set_desired_square(desired_square.x, desired_square.y)
		zombie.mode = zombie.MODE_MOVE

func zombie_hit(zombie, x, y):
	zombie.melee_hit(x, y)
	var remaining = inventory_screen.update_armor_durability(zombie.num)
	hero.lives -= remaining
	update_lives()
	
func is_zombie_time_finished():
	for zombie in zombies:
		if zombie.mode != zombie.MODE_STOP:				
			return false
			
	return true

func get_zombies(square_x, square_y):
	var z = []
	for zombie in zombies:
		if zombie.square.x == square_x and zombie.square.y == square_y:
			z.append(zombie)
	return z
	
func unmark_all_zombies():
	for zombie in zombies:
		zombie.unmark()
		
func mark_valid_zombies():
	if current_action == ACTION_ATTACK:
		var z = []
		var vector = Vector2()
		var target
		if _can_move_up(hero.square):
			target = get_zombies(hero.square.x, hero.square.y - 1)
			z += target
			vector.x = hero.square.x
			vector.y = hero.square.y - 1
			if current_weapon and current_weapon.weapon_range > 1 and not target and _can_move_up(vector):
				z+= get_zombies(hero.square.x, hero.square.y - 2)
		
		if _can_move_down(hero.square):
			target = get_zombies(hero.square.x, hero.square.y + 1)
			z += target
			vector.x = hero.square.x
			vector.y = hero.square.y + 1
			if current_weapon and current_weapon.weapon_range >1 and not target and _can_move_down(vector):
				z += get_zombies(hero.square.x, hero.square.y + 2)
			
		if _can_move_left(hero.square):
			target = get_zombies(hero.square.x - 1, hero.square.y)
			z += target
			vector.x = hero.square.x -1
			vector.y = hero.square.y
			if current_weapon and current_weapon.weapon_range >1 and not target and _can_move_left(vector):
				z += get_zombies(hero.square.x - 2, hero.square.y)
			
		if _can_move_right(hero.square):
			target = get_zombies(hero.square.x + 1, hero.square.y)
			z += target
			vector.x = hero.square.x + 1
			vector.y = hero.square.y
			if current_weapon and current_weapon.weapon_range >1 and not target and _can_move_right(vector):
				z += get_zombies(hero.square.x + 2, hero.square.y)
		
		for zombie in z:
			zombie.mark()
	

func _on_WalkButton_pressed():
	get_node("HUD/Bg/WalkButton").set_disabled(true)
	get_node("HUD/Bg/AttackButton").set_disabled(false)
	current_action = ACTION_WALK
	unmark_all_zombies()
	draw_valid_squares()


func _on_AttackButton_pressed():
	get_node("HUD/Bg/AttackButton").set_disabled(true)
	get_node("HUD/Bg/WalkButton").set_disabled(false)
	current_action = ACTION_ATTACK
	hide_all_squares()
	mark_valid_zombies()

func update_lives():
	if hero.lives >0:
		get_node("HUD/Bg/LifeContainer/Life1").fill()
	else:
		get_node("HUD/Bg/LifeContainer/Life1").empty()
	
	if hero.lives >1:
		get_node("HUD/Bg/LifeContainer/Life2").fill()
	else:
		get_node("HUD/Bg/LifeContainer/Life2").empty()
		
	if hero.lives >2:
		get_node("HUD/Bg/LifeContainer/Life3").fill()
	else:
		get_node("HUD/Bg/LifeContainer/Life3").empty()
		
func damage_zombie():
	var attack_power = 1
	if current_weapon != null:
		attack_power = current_weapon.power
	else:
		var remaining = inventory_screen.update_armor_durability(1)
		hero.lives -= remaining
		
	current_zombie.inc_num(-attack_power)
	if (current_zombie.num <=0):
		kill_zombie(current_zombie)
		
func player_atack_end():
	get_node("Hero/Camera2D").current = true
	inventory_screen.update_weapon_durability()
	update_lives()
	unmark_all_zombies()
	mark_valid_zombies()
	finish_action()
		

func player_melee_hit():
	if current_weapon == null:
		show_player_damage_effect()
		if current_armor == null:
			set_tip("noweapon")
		else:
			set_tip("armor")
	damage_zombie()
		
func show_player_damage_effect():
	get_node("HUD/HitIndicator").visible = true
	yield(get_tree().create_timer(0.2),"timeout")
	get_node("HUD/HitIndicator").visible = false

func _on_canMove_gui_input( ev, direction ):
	if ev is InputEventMouseButton:
		if ev.button_index == BUTTON_LEFT:
			if ev.pressed:
				if mode == MODE_PLAYER_ACTION and current_action == ACTION_WALK:
					_move_hero(direction)


func _on_InventoryButton_pressed():
	set_tip("inventory")
	check_tips()
	inventory_screen.show()


func _on_SearchButton_pressed():
	is_search_action = true
	var current_tile_item = _get_search_item()
	get_node("HUD/SearchScreen").set_item(current_tile_item)
	get_node("HUD/SearchScreen").show()
	

func take_item(item_num):	
	remove_search_icon()
	inventory_screen.add_item(item_num)
	inventory_screen.show()
	if item_num == globals.ITEM_KNIFE:
		set_tip("skip")
	else:
		set_tip("inventory")
		check_tips()
	
	
func remove_search_icon():
	map.get_node("search").set_cell(hero.square.x, hero.square.y, -1)
	for search_point in search_points:
		if search_point.square.x == hero.square.x and search_point.square.y == hero.square.y:
			remove_child(search_point)
			search_points.erase(search_point)
			break
	_update_search_button()
	
func discard_item():
	remove_search_icon()
	finish_action()
	
func story_closed():
	if mode == MODE_END:
		get_tree().change_scene("res://SelectLevel.tscn")
	else:
		check_tips()
	
func inventory_screen_closed():
	if is_search_action:
		is_search_action = false
		finish_action()
		
func _on_SkipButton_pressed():
	finish_action()
	
func set_tip(t):
	if not globals.settings.tips_shown.has(t):
		tip = t

func _on_Options_pressed():
	get_node("HUD/OptionsScreen").show()

func start_music():
	if globals.settings.music:
		get_node("Music").stream = music
		get_node("Music").play(0)
		
func start_stop_music():
	if globals.settings.music:
		start_music()
	else:
		get_node("Music").stop()
		
		
