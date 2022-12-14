extends Node2D

signal end_state(state)

var parent = null
var children = []

var heuristic_rule = null

var moving_AI = null
var player_AI = null
var agent_AI = null

const DEPTH_SIZE = 6
var depth = 0

var h_value = 0
var state_link = "res://scenes/state.tscn"

var self_turn = false
var move_num = -1

var cur_state = {
	player_pos_x = 0,
	player_pos_y = 0,
	self_pos_x = 0,
	self_pos_y = 0,
	player_max_hp = 0,
	player_max_mp = 0,
	player_hp = 0,
	player_mp = 0,
	self_max_hp = 0,
	self_max_mp = 0,
	self_hp = 0,
	self_mp = 0,
	arena_x = 0,
	arena_y = 0
}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# ALWAYS ASSUME EVERY MOVE IS POSSIBLE BEFORE REACHING HERE
func perform_move():
	print("Depth: "+str(depth)+ " Let's perform a move!: "+str(self_turn) + " with move num: "+str(move_num))
	if self_turn:
		var move_set_num = move_num - moving_AI.get_move_type_bounds(moving_AI.get_move_type(move_num))
		match(moving_AI.get_move_type(move_num)):
			0: # Move
				match(move_num):
					0: cur_state.self_pos_y -= moving_AI.get_move_dist(move_num)
					1: cur_state.self_pos_y += moving_AI.get_move_dist(move_num)
					2: cur_state.self_pos_x -= moving_AI.get_move_dist(move_num)
					3: cur_state.self_pos_x += moving_AI.get_move_dist(move_num)
					_: print('Invalid state move distance')
				
				if cur_state.self_pos_x < 0:
					cur_state.self_pos_x = 0
				elif cur_state.self_pos_x > cur_state.arena_x:
					cur_state.self_pos_x  = cur_state.arena_x
				elif cur_state.self_pos_y < 0:
					cur_state.self_pos_y = 0
				elif cur_state.self_pos_y > cur_state.arena_y:
					cur_state.self_pos_y = cur_state.arena_y
				
			1: # Regen Moves
				cur_state.self_mp += moving_AI.get_regen(move_set_num,1)
				if cur_state.self_mp > cur_state.self_max_mp:
					cur_state.self_mp = cur_state.self_max_mp
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
		var move_set_num = move_num - moving_AI.get_move_type_bounds(moving_AI.get_move_type(move_num))
		match(moving_AI.get_move_type(move_num)):
			0: # Move
				match(move_num):
					0: cur_state.player_pos_y -= moving_AI.get_move_dist(move_num)
					1: cur_state.player_pos_y += moving_AI.get_move_dist(move_num)
					2: cur_state.player_pos_x -= moving_AI.get_move_dist(move_num)
					3: cur_state.player_pos_x += moving_AI.get_move_dist(move_num)
					_: print('Invalid state move distance')
				
				if cur_state.player_pos_x < 0:
					cur_state.player_pos_x = 0
				elif cur_state.player_pos_x > cur_state.arena_x:
					cur_state.player_pos_x  = cur_state.arena_x
				elif cur_state.player_pos_y < 0:
					cur_state.player_pos_y = 0
				elif cur_state.player_pos_y > cur_state.arena_y:
					cur_state.player_pos_y = cur_state.arena_y
				
			1: # Regen Moves
				cur_state.player_mp += moving_AI.get_regen(move_set_num,1)
				if cur_state.player_mp > cur_state.player_max_mp:
					cur_state.player_mp = cur_state.player_max_mp
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
#	calculate_state()

# Turn is true if it's the AI's turn
func prep_dets(dets, mn=-1, d=0, parent=null, turn=false):
#	self.connect('end_state',cluster,'_on_finish_end_state')
	self.parent = parent
	
	cur_state.player_pos_x = dets.player_pos_x
	cur_state.player_pos_y = dets.player_pos_y
	cur_state.self_pos_x = dets.self_pos_x
	cur_state.self_pos_y = dets.self_pos_y
	cur_state.player_max_hp = dets.player_max_hp
	cur_state.player_max_mp = dets.player_max_mp
	cur_state.player_hp = dets.player_hp
	cur_state.player_mp = dets.player_mp
	cur_state.self_max_hp = dets.self_max_hp
	cur_state.self_max_mp = dets.self_max_mp
	cur_state.self_hp = dets.self_hp
	cur_state.self_mp = dets.self_mp
	cur_state.arena_x = dets.arena_x
	cur_state.arena_y = dets.arena_y
	
	move_num = mn
	depth = d
	self.self_turn = turn
	
	# Adds the AI unto the state by grabbing it from
	# the state_cluster.
	player_AI = parent.get_human_ai()
	agent_AI = parent.get_agent_ai()
	
	if self_turn: moving_AI = agent_AI
	else: moving_AI = player_AI
	
	# We add them as a child of the parent state only
	# if the move can actually be performed in order
	# to avoid redundancy.
	if is_move_playable():
		add_to_group("depth_"+str(d))
		parent.add_child_state(self)
		perform_move()
		return true
	else:
		# No use in keeping dead weight.
		self.queue_free()
		return false

# Simply checks if out of HP
func is_game_over():
	if cur_state.self_hp <= 0 or cur_state.player_hp <= 0:
		return true
	return false

func is_player_win():
	if cur_state.player_hp <= 0 and cur_state.self_hp > 0:
		return true
	return false

func is_agent_win():
	if cur_state.player_hp > 0 and cur_state.self_hp <= 0:
		return true
	return false


# Checks current move and self_turn
func is_move_playable():
	if is_game_over(): return false
	
	if self_turn and agent_AI.is_move_playable(move_num,cur_state.self_mp):
		return true
	elif not self_turn and player_AI.is_move_playable(move_num,cur_state.player_mp):
		return true
	
	print('Unknown move playable condition! assuming state can no longer go on!')
	return false

func add_child_state(s): children.append(s)

func set_heuristic_rule(h): heuristic_rule = h
func set_h_value(h): h_value = h

func get_h_value(): return h_value
func get_move(): return move_num
func get_cur_dets(): return cur_state
func get_depth(): return depth
func get_state_parent(): return parent
func get_state_children(): return children

func get_human_ai(): return player_AI
func get_agent_ai(): return agent_AI

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
	
	# Use manhattan distance depending on AI
	
	# Optionals (These mean POSSIBLE attacks or regen moves)
	# actually do we even need these? we're calculating based on
	# current state and not state of 3 whole turns! should we do depth 9 instead ?
	
	
	# HP/MP Calculation
	# AI should place HP in high regard, therefore it is
	# multiplied by 2 in terms of heuristic rules
	final_value -= cur_state.player_hp*2
	final_value -= cur_state.player_mp/4
	final_value += cur_state.self_hp*2
	final_value += cur_state.self_mp/4
	
	# Game over
	if cur_state.player_hp <= 0: final_value = INF
	elif cur_state.self_hp <= 0: final_value = -INF
	
	return final_value
	
	print('Finished state '+str(move_num)+' at '+str(depth)+'. H:'+str(final_value))

# dir is the position number
# turn is true if it's the AI's turn to check around it
# defaults to self_turn
func check_grid(dir, turn=self_turn):
	var x
	var y
	
	# adjusts based on turn
	var atk_x = 0
	var atk_y = 0
	
	if !turn:
		x = cur_state.self_pos_x
		y = cur_state.self_pos_y
		
		atk_x = cur_state.player_pos_x
		atk_y = cur_state.player_pos_y
	else:
		x = cur_state.player_pos_x
		y = cur_state.player_pos_y
		
		atk_x = cur_state.self_pos_x
		atk_y = cur_state.self_pos_y
	
	
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
	
	if atk_x == x and atk_y == y:
		return true
	else:
		return false

func find_opponent(specific=null):
	if specific == null:
		if check_grid(0): return 0
		if check_grid(1): return 1
		if check_grid(2): return 2
		if check_grid(3): return 3
		if check_grid(4): return 4
		if check_grid(5): return 5
		if check_grid(6): return 6
		if check_grid(7): return 7
		if check_grid(8): return 8
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

# Note: only checks for own turn
func check_atk_distance(grid):
	var hits = []
#	print("GRID: ")
#	print(grid)
	if grid[0]: hits.append(check_grid(0))
	if grid[1]: hits.append(check_grid(1))
	if grid[2]: hits.append(check_grid(2))
	if grid[3]: hits.append(check_grid(3))
	if grid[4]: hits.append(check_grid(4))
	if grid[5]: hits.append(check_grid(5))
	if grid[6]: hits.append(check_grid(6))
	if grid[7]: hits.append(check_grid(7))
	if grid[8]: hits.append(check_grid(8))
	
	for hit in hits:
		if hit == true: return true
	
	return false

# Grabs manhattan distance of two points.
func get_cur_distance():
	var x = abs(cur_state.player_pos_x - cur_state.self_pos_x)
	var y = abs(cur_state.player_pos_y - cur_state.self_pos_y)
	var dist = x + y
	return dist
