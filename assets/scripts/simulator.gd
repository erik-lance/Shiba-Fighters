extends Node2D

# Responsible for calculating best route at a certain state.
# Calculates all possible moves
onready var state = []
var heuristics = []
# Remove the first state in case there are no valid moves in the future.

var state_link = "res://scenes/state.tscn"

var cur_calc_state = 0
var cur_dets = null

var player_first = true
var ai_human = null
var ai_agent = null

var first_player = null
var second_player = null

var root_state = null

var depth_size = 6

var is_ai_first_card = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func prep_sim(dets):
	cur_dets = dets

func prepare_tree():
	# Prepares a root node where depth is 0 and no move is done.
	root_state = load(state_link).instance()
	add_child(root_state)
	root_state.prep_dets(cur_dets)
	
	# Prepare depth 1
	prepare_children(root_state, true)
	
	var cur_depth = 1
	
	# Prepare depth 2+
	# This is done by checking for children at depth X
	# If no children found, expand.
#	for n in root_state.get_children():
#		n.prepare_children(n, false)
	
	# CONCERN: Check for non-existent groups
	# uses node groups in godot
	var cur_turn = false
	while (cur_depth < depth_size-1):
		for _node in get_tree().get_nodes_in_group("depth_"+str(cur_depth)):
			_node.prepare_children(_node, cur_turn)
		
		cur_turn = !cur_turn

func prepare_children(node, is_first_player):
	# We append is_ai_first card because if it's true, and it's first player, it plays as normal.
	# if it's false and first player, it reveals the human is the first player and it's not their
	# turn yet.
	
	if is_first_player:
		for i in first_player.get_deck_size():
			var new_state = load(state_link).instance()
			node.add_child(new_state)
			
			# Prepares with dets of parent, a move num, their parent's depth+1, and the parent itself
			new_state.prep_dets(node.get_cur_dets(), i, node.get_depth()+1, node, is_ai_first_card)
	else:
		for i in second_player.get_deck_size():
			var new_state = load(state_link).instance()
			node.add_child(new_state)
			
			# Prepares with dets of parent, a move num, their parent's depth+1, and the parent itself
			new_state.prep_dets(node.get_cur_dets(), i, node.get_depth()+1, node, !is_ai_first_card)

# Cleans the node groups made from depths
func clean_node_groups():
	var cur_depth = 1
	while (cur_depth < depth_size-1):
		var group_name = "depth_"+str(cur_depth)
		for _node in get_tree().get_nodes_in_group(group_name):
				_node.remove_from_group(group_name)

# When you found the best heuristic, move the state cluster to
# $SelectedCluster and then delete all other state clusters.
# We only need the top most state cluster to grabe the 3 state sequence
func alpha_beta_search(s):
	# Will contain state path of best path
	var walk_path = []
	
	var a = -INF
	var b = INF
	
	# Evaluates the utility
	var v = 0
	
	# Since AI is the maximizer and player is the minimizer, it has to adjust accordingly.
	if is_ai_first_card:
		v = min_value(s,a,b)
	else:
		v = max_value(s,a,b)
	
	walk_path.append(root_state)
	var cur_depth = 1
	while (true):
		# Grabs last element
		var cur_search = walk_path.back()
		if cur_search.child_count() <= 0: break
		
		var best_node = null
		var best_val = 0
		
		var is_ai_turn = false
		if is_ai_first_card:
			if cur_depth % 2 != 0: is_ai_turn = true
			else: is_ai_turn = false
		else:
			if cur_depth % 2 == 0: is_ai_turn = false
			else: is_ai_turn = true
		
		for child_state in cur_search.get_state_children():
			if is_ai_turn: # Maximize
				child_state.get_h_value() > best_val
				best_node = child_state
				best_val = child_state.get_h_value()
			else: # Minimize
				child_state.get_h_value() < best_val
				best_node = child_state
				best_val = child_state.get_h_value()
		
		walk_path.append(best_node)
	
	return walk_path

func max_value(s,alpha,beta):
	# Static evaluation of state
	if(s.is_move_playable()):
		var state_h_value = s.calculate_state()
		s.set_h_value(state_h_value)
		return state_h_value
	else:
		print("Reached immovable state?")
	
	var maximizing_value = -INF
	for a in s.get_state_children():
		maximizing_value = max(maximizing_value,min_value(a,alpha,beta))

		# by doign this override, we can get the best state from navigating.
		s.set_h_value(maximizing_value)
		
		if maximizing_value >= beta: return maximizing_value
		
		alpha = max(alpha, maximizing_value)
	
	return maximizing_value

func min_value(s, alpha, beta):
	# Static evaluation of state
	if(s.is_move_playable()):
		var state_h_value = s.calculate_state()
		s.set_h_value(state_h_value)
		return state_h_value
	else:
		print("Reached immovable state for minimizer!")
	
	
	var minimizing_value = INF
	for a in s.get_state_children():
		minimizing_value = min(minimizing_value, max_value(a,alpha,beta))
		if minimizing_value <= alpha: return minimizing_value
		
		beta = min(beta,minimizing_value)
	
	return minimizing_value

# Feed Link
func load_ai(h="res://scenes/arena/ai/shiba_ai.tscn",a="res://scenes/arena/ai/shiba_ai.tscn"):
	var ai_h = load(h).instance()
	var ai_a = load(a).instance()
	
	$AIPlayer.add_child(ai_h)
	$AIAgent.add_child(ai_a)
	
	ai_human = ai_h
	ai_agent = ai_a

func get_human_ai(): return ai_human
func get_agent_ai(): return ai_agent
func get_first_player(): return first_player
func get_second_player(): return second_player

func get_root(): return root_state

func set_human_first():
	first_player = ai_human
	second_player = ai_agent
	is_ai_first_card = false

func set_agent_first():
	first_player = ai_agent
	second_player = ai_human
	is_ai_first_card = true

func _on_finish_cluster_tree(val):
	if cur_calc_state < ai_human.get_deck_size():
		pass
	else:
		pass

# This is called after a state reaches depth 3 and finishes minmaxing the
# heuristic values.
func _on_finish_min_max_state():
	pass
	#prep_state(cur_dets,cur_calc_state)

func _on_finish_calculating():
	pass
