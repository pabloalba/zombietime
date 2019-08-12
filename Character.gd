extends Node2D
signal melee_hit
signal atack_end

const MODE_HIT_FORWARD = 0
const MODE_HIT_BACKWARD = 1
const MODE_MOVE = 2
const MODE_STOP = 3
const MELEE_SPEED = 750


var mode = MODE_STOP
var desired_position = Vector2()
var desired_square = Vector2()
var square = Vector2()
var old_square = Vector2()
var base_speed = 500
var speed = 500
var limit = 10


func _ready():
	pass
	
func set_square(x, y):
	self.position.x = 256 * x + 64
	self.position.y = 256 * y + 64
	desired_position.x = self.position.x
	desired_position.y = self.position.y
	square.x = x
	square.y = y
	desired_square.x = x
	desired_square.y = y
	
func set_desired_square(x, y):
	desired_position.x = 256 * x + 64
	desired_position.y = 256 * y + 64
	desired_square.x = x
	desired_square.y = y
	
func _process(delta):
	var end_x = false
	var end_y = false
	
	if abs(desired_position.x - self.position.x) < limit:
		end_x = true
		if mode != MODE_HIT_FORWARD:
			self.position.x = desired_position.x
			
	elif desired_position.x > self.position.x:
		self.position.x += speed * delta
	else:
		self.position.x -= speed * delta
		
		
	if abs(desired_position.y - self.position.y) < limit:
		end_y = true
		if mode != MODE_HIT_FORWARD:
			self.position.y = desired_position.y
	elif desired_position.y > self.position.y:
		self.position.y += speed * delta
	else:
		self.position.y -= speed * delta
		
	if end_x and end_y:
		square.x = desired_square.x
		square.y = desired_square.y
		if mode == MODE_HIT_FORWARD:			
			set_desired_square(old_square.x, old_square.y)
			mode = MODE_HIT_BACKWARD
			limit = limit / 10
			emit_signal("melee_hit")
			
			
		elif mode == MODE_HIT_BACKWARD:	
			speed = base_speed		
			mode = MODE_STOP
			emit_signal("atack_end")
		else:
			mode = MODE_STOP
	
func melee_hit(x, y):
	speed = MELEE_SPEED
	limit = limit * 10
	old_square.x = square.x
	old_square.y = square.y
	set_desired_square(x, y)
	mode = MODE_HIT_FORWARD