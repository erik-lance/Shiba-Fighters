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
	root_state.prep_dets(cur_dets, -1, 0, self)
	
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
	while (cur_depth < depth_size):
		for _node in get_tree().get_nodes_in_group("depth_"+str(cur_depth)):
			prepare_children(_node, cur_turn)
		
		cur_turn = !cur_turn
		cur_depth += 1

func prepare_children(node, is_first_player):
	# We append is_ai_first card because if it's true, and it's first player, it plays as normal.
	# if it's false and first player, it reveals the human is the first player and it's not their
	# turn yet.
	
	var player_to_prep = null
	var card_owner = null
	
	# If it is AI turn, card_owner = true
	if is_first_player: 
		player_to_prep = first_player
		if is_ai_first_card: card_owner = true
		else: card_owner = false
	else: 
		player_to_prep = second_player
		if is_ai_first_card: card_owner = false
		else: card_owner = true
	
	var best_child = null
	var best_val = 0
	
	if card_owner: best_val = -INF
	else: best_val = INF
	
	for i in player_to_prep.get_deck_size():
		var new_state = load(state_link).instance()
		node.add_child(new_state)
		# Prepares with dets of parent, a move num, their parent's depth+1, and the parent itself
		var exist_node = new_state.prep_dets(node.get_cur_dets(), i, node.get_depth()+1, node, card_owner)
		
		# If node won't be deleted, check if this child is the best child, if so, add and continue
		# deepening, else, remove it.
		
		# This is the move-ordering in AB pruning.
		# It'll only check moves where it became better, so it's not disregarding previous "good" moves.
		# It is simply removing useless moves.
		if exist_node:
#			new_state.perform_move()
			var cur_val = new_state.calculate_state()
			
			if card_owner:
				if cur_val > best_val:
					new_state.set_h_value(cur_val)
					best_child = new_state
					best_val = cur_val
				else:
					node.remove_child(new_state)
					var group_name = "depth_"+str(node.get_depth()+1)
					new_state.remove_from_group(group_name)
					new_state.queue_free()
			else:
				if cur_val < best_val:
					new_state.set_h_value(cur_val)
					best_child = new_state
					best_val = cur_val
				else:
					node.remove_child(new_state)
					var group_name = "depth_"+str(node.get_depth()+1)
					new_state.remove_from_group(group_name)
					new_state.queue_free()
	
	


# Cleans the node groups made from depths
func clean_node_groups():
	var cur_depth = 1
	while (cur_depth < depth_size-1):
		var group_name = "depth_"+str(cur_depth)
		for _node in get_tree().get_nodes_in_group(group_name):
				_node.remove_from_group(group_name)

# Searches the whole tree. Once finished, creates a walk to the path
# and returns the array walk_path in order from root to last node to reach.
func alpha_beta_search(s):
	print("\n\n\n ----------- BEGIN AB SEARCH -----------")
	
	# Will contain state path of best path
	var walk_path = []
	
	var a = -INF
	var b = INF
	
	# Evaluates the utility
	var v = 0
	
	# Since AI is the maximizer and player is the minimizer, it has to adjust accordingly.
	if is_ai_first_card:
		v = max_value(s,a,b)
	else:
		v = min_value(s,a,b)
	
	walk_path.append(root_state)
	var cur_depth = 1
	while (true):
		# Grabs last element
		var cur_search = walk_path.back()
		if cur_search.get_child_count() <= 0: break
		
		var best_node = null
		var best_val = 0
		
		var is_ai_turn = false
		if is_ai_first_card:
			if cur_depth % 2 != 0: is_ai_turn = true
			else: is_ai_turn = false
		else:
			if cur_depth % 2 == 0: is_ai_turn = false
			else: is_ai_turn = true
		
		for child_state in cur_search.get_children():
#			print("State children: ")
#			print(cur_search.get_children())
			if is_ai_turn: # Maximize
				child_state.get_h_value() > best_val
				best_node = child_state
				best_val = child_state.get_h_value()
			else: # Minimize
				child_state.get_h_value() < best_val
				best_node = child_state
				best_val = child_state.get_h_value()
		
		walk_path.append(best_node)
	
	print("\n\n -- Final Path --")
	print(walk_path)
	for node in walk_path:
		print(str(node.get_depth()) + ": Move: " +str(node.get_move()) +"  H: "+ str(node.get_h_value()) )
	return walk_path

func max_value(s,alpha,beta):
	# Evaluates starting state
	if(s.get_depth() == 0):
		var state_h_value = s.calculate_state()
		s.set_h_value(state_h_value)
		return state_h_value

	# Static evaluation of state
	if(s.is_move_playable()):
		var state_h_value = s.calculate_state()
		s.set_h_value(state_h_value)
		return state_h_value
	else:
		print("Reached immovable state?")
		print("---- CUR DETS and MOVE NUM ----")
		print(s.get_cur_dets())
		print(s.get_move())
	
	var maximizing_value = -INF
	for a in s.get_state_children():
		maximizing_value = max(maximizing_value,min_value(a,alpha,beta))

		# by doign this override, we can get the best state from navigating.
		s.set_h_value(maximizing_value)
		
		if maximizing_value >= beta: return maximizing_value
		
		alpha = max(alpha, maximizing_value)
	
	return maximizing_value

func min_value(s, alpha, beta):
	# Evaluates starting state
	if(s.get_depth() == 0):
		var state_h_value = s.calculate_state()
		s.set_h_value(state_h_value)
		return state_h_value
	
	# Static evaluation of state
	if(s.is_move_playable()):
		var state_h_value = s.calculate_state()
		s.set_h_value(state_h_value)
		return state_h_value
	else:
		print("Reached immovable state for minimizer!")
		print("---- CUR DETS and MOVE NUM ----")
		print(s.get_cur_dets())
		print(s.get_move())
	
	
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
func get_cur_dets(): return cur_dets

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
