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

var root_state = null

var depth_size = 6

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
	for n in root_state.get_children():
		n.prepare_children(n, false)
	
	# CONCERN: Check for non-existent groups
	# uses node groups in godot
	var cur_turn = true
	while (cur_depth < depth_size-1):
		for _node in get_tree().get_nodes_in_group("depth_"+str(cur_depth)):
			_node.prepare_children(_node, cur_turn)
		
		cur_turn = !cur_turn

func prepare_children(node, is_first_player):
	if is_first_player:
		for i in ai_human.get_deck_size():
			var new_state = load(state_link).instance()
			node.add_child(new_state)
			
			# Prepares with dets of parent, a move num, their parent's depth+1, and the parent itself
			new_state.prep_dets(node.get_cur_dets(), i, node.get_depth()+1, node)
	else:
		for i in ai_agent.get_deck_size():
			var new_state = load(state_link).instance()
			node.add_child(new_state)
			
			# Prepares with dets of parent, a move num, their parent's depth+1, and the parent itself
			new_state.prep_dets(node.get_cur_dets(), i, node.get_depth()+1, node)

# Cleans the node groups made from depths
func clean_node_groups():
	var cur_depth = 1
	while (cur_depth < depth_size-1):
		var group_name = "depth_"+str(cur_depth)
		for _node in get_tree().get_nodes_in_group(group_name):
				_node.remove_from_group(group_name)

# Prepares a cluster state to calculate states
# @start_state - state to branch out off
# @m - move
# @p - parent
# @d - depth
func prep_state_cluster(start_state,m,p=self,d=0):
	var new_cluster = load("res://scenes/state_cluster.tscn").instance()
	add_child(new_cluster)
	state.append(new_cluster)
	
	new_cluster.set_parent(p)
	new_cluster.set_depth(d)
	new_cluster.set_move(cur_calc_state)
	new_cluster.set_start_state(cur_dets)
	new_cluster.load_ai()
	
	cur_calc_state += 1

# When you found the best heuristic, move the state cluster to
# $SelectedCluster and then delete all other state clusters.
# We only need the top most state cluster to grabe the 3 state sequence
func alpha_beta_search(s):
	var v = max_value(s,-9999,9999)

func max_value(s,alpha,beta):
	# Static evaluation of state
	if(s.is_move_playable()):
		var state_h_value = s.calculate_state()
		s.set_h_value(state_h_value)
		return state_h_value
#	elif(s.is_agent_win()):
#		var state_h_value = s.calculate_state()+9999
#		s.set_h_value(state_h_value)
#		return state_h_value
		
#	if not s.is_move_playable(): return s.get_h_value()
	
	var maximizing_value = -INF
	for a in s.get_state_children():
		maximizing_value = max(maximizing_value,min_value(a,alpha,beta))
		
		
		# This is so that the value updates all the way to the parent to choose the best route
		# Kaso we want the to grab the individual states right(?)
		
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
