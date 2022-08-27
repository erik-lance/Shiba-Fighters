extends Node2D

signal end_state()

var root = null
var heuristic_rule = null
var player_AI = null

var depth = -1

var h_value = 0
var state_link = "res://scenes/state.tscn"

var possible_state = false

var self_turn = false
var move_num = -1

var cur_state = {
	player_pos_x = 0,
	player_pos_y = 0,
	self_pos_x = 0,
	self_pos_y = 0,
	player_hp = 0,
	player_mp = 0,
	self_hp = 0,
	self_mp = 0
}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func prep_dets(dets, r, mn=-1, d=-1, possible=false):
	if possible:
		root = r
		cur_state.player_pos_x = dets.player_pos_x
		cur_state.player_pos_y = dets.player_pos_y
		cur_state.self_pos_x = dets.self_pos_x
		cur_state.self_pos_y = dets.self_pos_y
		cur_state.player_hp = dets.player_hp
		cur_state.player_mp = dets.player_mp
		cur_state.self_hp = dets.self_hp
		cur_state.self_mp = dets.self_mp
		
		move_num = mn
		depth = d
		
		# Once reaches depth 3 (Final depth)
		if d == 3:
			self.connect('end_state',root,'_on_finish_min_max_state')
		
		calculate_state()
	else:
		root = r
		move_num = mn
		depth = d
		self.connect('end_state',root,'_on_finish_min_max_state')
		print('Finished impossible state')
		if d==3:
			emit_signal("end_state")

func set_possible_state(t=false):
	possible_state = t

func set_h_value(h):
	h_value = h

func get_h_value():
	return h_value


# --------------------------------------------------- #
# ---------------- CALCULATION TOOLS ---------------- #
# --------------------------------------------------- #
func calculate_state():
	# TODO: Add heuristic_rule properly soon	
	
	
	# Heuristic Rules
	# Calculate Position based on dmg_proximity
	# Optionals: ------------------------------
	# Calculate Regen (IF CONFIRMED!)
	# Calculate Defense (IF CONFIRMED!)
	# Calculate Attacks (IF CONFIRMED!)
	# -----------------------------------------
	# MinMax Final HP/MP based on raw number
	
	
	print('Finished state')
	emit_signal("end_state")

func check_self_grid(dir):
	var x = cur_state.self_pos_x
	var y = cur_state.self_pos_y
	
	match(dir):
		0:
			x-=1
			y-=1
		1:
			y-=1
		2:
			x+=1
			y-=1
		3:
			x-=1
		5:
			x+=1
		6:
			x-=1
			y+=1
		7:
			y+=1
		8:
			x+=1
			y+=1
	
	if cur_state.player_pos_x == x and cur_state.player_pos_y == y:
		return true
	else:
		return false

func check_atk_distance(grid):
	pass

# Grabs manhattan distance of two points.
func get_cur_distance():
	var x = abs(cur_state.player_pos_x - cur_state.self_pos_x)
	var y = abs(cur_state.player_pos_y - cur_state.self_pos_y)
	var dist = x + y
	return dist
