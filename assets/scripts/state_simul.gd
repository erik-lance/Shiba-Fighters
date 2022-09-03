extends Node2D

signal end_state()

var root = null
var heuristic_rule = null
var moving_AI = null

var player_AI = null
var agent_AI = null

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

func perform_move():
	if self_turn:
		if moving_AI.is_move_playable(move_num,cur_state.self_mp):
			var move_set_num = move_num - moving_AI.get_move_type_bounds(moving_AI.get_move_type(move_num))
			match(moving_AI.get_move_type(move_num)):
				0: # Move
					match(move_num):
						0: cur_state.self_pos_y -= moving_AI.get_move_dist(move_num)
						1: cur_state.self_pos_y += moving_AI.get_move_dist(move_num)
						2: cur_state.self_pos_x -= moving_AI.get_move_dist(move_num)
						3: cur_state.self_pos_x += moving_AI.get_move_dist(move_num)
						_: print('Invalid state move distance')
				1: # Regen Moves
					cur_state.self_mp += moving_AI.get_regen(move_set_num,1)
				2: # Guard Moves
					pass
				3: # Attack Moves
					cur_state.self_mp -= moving_AI.get_lethality(move_set_num,1)
					var atk_grid = moving_AI.get_grid_atk(move_set_num)
					if check_atk_distance(atk_grid):
						cur_state.player_hp -= moving_AI.get_lethality(move_set_num)
				_:
					print('Unknown move type!')
	else:
		if moving_AI.is_move_playable(move_num,cur_state.player_mp):
			var move_set_num = move_num - moving_AI.get_move_type_bounds(moving_AI.get_move_type(move_num))
			match(moving_AI.get_move_type(move_num)):
				0: # Move
					match(move_num):
						0: cur_state.player_pos_y -= moving_AI.get_move_dist(move_num)
						1: cur_state.player_pos_y += moving_AI.get_move_dist(move_num)
						2: cur_state.player_pos_x -= moving_AI.get_move_dist(move_num)
						3: cur_state.player_pos_x += moving_AI.get_move_dist(move_num)
						_: print('Invalid state move distance')
				1: # Regen Moves
					cur_state.player_mp += moving_AI.get_regen(move_set_num,1)
				2: # Guard Moves
					pass
				3: # Attack Moves
					cur_state.player_mp -= moving_AI.get_lethality(move_set_num,1)
					var atk_grid = moving_AI.get_grid_atk(move_set_num)
					if check_atk_distance(atk_grid):
						cur_state.self_hp -= moving_AI.get_lethality(move_set_num)
				_:
					print('Unknown move type!')
	
	# Since the state has been adjusted accordingly based on move,
	# it is time to calculate the state's heuristics
	calculate_state()


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
		
		perform_move()
	else:
		root = r
		move_num = mn
		depth = d
		self.connect('end_state',root,'_on_finish_min_max_state')
		print('Finished impossible state')
		if d==3:
			emit_signal("end_state")

func set_heuristic_rule(h):
	heuristic_rule = h

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
	var final_value = 0
	# TODO: Add heuristic_rule properly soon	
	# Minimizer is Human
	# Maximizer is Agent
	
	# Heuristic Rules
	# Calculate Position based on dmg_proximity
	# Optionals: ------------------------------
	# Calculate Regen (IF CONFIRMED!)
	# Calculate Defense (IF CONFIRMED!)
	# Calculate Attacks (IF CONFIRMED!)
	# -----------------------------------------
	# MinMax Final HP/MP based on raw number
	
	# Position calculation
	final_value += agent_AI.get_proximity(find_opponent(true))
	final_value -= player_AI.get_proximity(find_opponent(false))
	
	# Optionals (These mean POSSIBLE attacks or regen moves)
	
	
	
	# HP/MP Calculation
	final_value -= cur_state.player_hp
	final_value -= cur_state.player_mp
	final_value += cur_state.self_hp
	final_value += cur_state.self_mp
	
	
	print('Finished state')
	emit_signal("end_state")

func check_grid(dir, turn=self_turn):
	var x
	var y
	
	if turn:
		x = cur_state.self_pos_x
		y = cur_state.self_pos_y
	else:
		x = cur_state.player_pos_x
		y = cur_state.player_pos_y
	
	
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

func find_opponent(specific=-1):
	if specific == -1:
		if check_grid(0): return 0
		if check_grid(1): return 1
		if check_grid(2): return 2
		if check_grid(3): return 3
		if check_grid(4): return 4
		if check_grid(5): return 5
		if check_grid(6): return 6
		if check_grid(7): return 7
		if check_grid(8): return 8
		return -1
	else:
		if check_grid(0, specific): return 0
		if check_grid(1, specific): return 1
		if check_grid(2, specific): return 2
		if check_grid(3, specific): return 3
		if check_grid(4, specific): return 4
		if check_grid(5, specific): return 5
		if check_grid(6, specific): return 6
		if check_grid(7, specific): return 7
		if check_grid(8, specific): return 8
		return -1
	

func check_atk_distance(grid):
#	var p_x = cur_state.player_pos_x
#	var p_y = cur_state.player_pos_y
#	var a_x = cur_state.self_pos_x
#	var a_y = cur_state.self_pos_y
	
#	if self_turn:
#		if grid[0][0]:
#			if a_x-1 == p_x and a_y-1 == p_y: return true
#		elif grid[0][1]:
#			if a_x == p_x and a_y-1 == p_y: return true
#		elif grid[0][2]:
#			if a_x+1 == p_x and a_y-1 == p_y: return true
#		elif grid[1][0]:
#			if a_x-1 == p_x and a_y == p_y: return true
#		elif grid[1][1]:
	# completely forgot the existence of check_grid
	
	var hits = []
	
	if grid[0][0]: hits.append(check_grid(0))
	if grid[0][1]: hits.append(check_grid(1))
	if grid[0][2]: hits.append(check_grid(2))
	if grid[1][0]: hits.append(check_grid(3))
	if grid[1][1]: hits.append(check_grid(4))
	if grid[1][2]: hits.append(check_grid(5))
	if grid[2][0]: hits.append(check_grid(6))
	if grid[2][1]: hits.append(check_grid(7))
	if grid[2][2]: hits.append(check_grid(8))
	
	for hit in hits:
		if hit == true: return true
	
	return false

# Grabs manhattan distance of two points.
func get_cur_distance():
	var x = abs(cur_state.player_pos_x - cur_state.self_pos_x)
	var y = abs(cur_state.player_pos_y - cur_state.self_pos_y)
	var dist = x + y
	return dist
