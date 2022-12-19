extends Node2D

signal cluster_done(m_num)

# This holds the 3 states to ensure the sequence
# Each state cluster will be laid out after that.

var human_ai = null
var agent_ai = null

var root_manager = null
var parent = null
var depth = 0

var states = []
var end_states = []
var cur_calc_state = 0

var turn_two = []
var turn_three = []


var cluster_children = []

var h_value = 0
var start_move = -1

var start_state = null
var end_state = null

var sequence = {
	move_1 = null,
	move_2 = null,
	move_3 = null
}

var cur_dets = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func load_ai(h,a):
	human_ai = h
	agent_ai = a

func get_human_ai(): return human_ai
func get_agent_ai(): return agent_ai

func set_manager(m): root_manager = m
func set_parent(p): parent = p
func set_depth(d): depth = d
func set_move(m): start_move = m
func set_start_state(s): start_state = s
func set_end_state(s): end_state = s

func set_start_dets(d): cur_dets = d

# This is for constructing a new cluster, not to be used
# inside a cluster, only inside the parent simulator
func prep_cluster(start_dets, m, p, h, a, d=0):
	self.set_start_dets(start_dets)
	self.set_parent(p)
	self.set_depth(d)
	self.set_move(m)
	
	self.load_ai(h,a)
	
	# Begins calculating
	begin_tree()

# This is only if we want to exceed depth 1
func new_state_cluster(start_dets,m,p=self,d=depth+1):
	var new_cluster = load("res://scenes/state_cluster.tscn").instance()
	root_manager.add_child(new_cluster)
	cluster_children.append(new_cluster)
	
	new_cluster.load_ai(human_ai, agent_ai)
	
	new_cluster.set_parent(p)
	new_cluster.set_depth(d)
	new_cluster.set_move(m)

# Prepares a new move state in this direction
# WILL PROBABLY ONLY BE USED ONCE FOR CLUSTERS
func prep_state(dets, m=-1):
	var new_state = load("res://scenes/state.tscn").instance()
	add_child(new_state)
	new_state.set_name('State '+states.size())
	start_state = new_state
	
	start_state.prep_dets(dets, self,m)
	#states[cur_calc_state].prep_dets(dets, self,m)
	cur_calc_state += 1

func begin_tree():
	prep_state(cur_dets, start_move)
	print('Done tree!')


func _on_finish_end_state(state):
	end_states.append(state)

func get_heuristic_value(): return h_value

# ALPHA-BETA MINIMAX PRUNING
# Find the state sequence	


# UPDATE, ALPHA BETA ONLY FOR SIMULATOR
# DONT USE ALPHA BETA HERE
# ONLY GRAB THE BEST OF EACH DEPTH
func alpha_beta_search(s):
	var v = max_value(s,-INF,INF)
	
	
	pass

func max_value(s, alpha, beta):
	if not s.is_move_playable(): return s.get_h_value()
	
	var maximizing_value = -INF
	for a in s.get_state_children():
		maximizing_value = max(maximizing_value,min_value(a,alpha,beta))
		
		
		# This is so that the value updates all the way to the parent to choose the best route
		# Kaso we want the to grab the individual states right(?)
		# s.set_h_value(maximizing_value)
		
		if maximizing_value >= beta: return maximizing_value
		
		alpha = max(alpha, maximizing_value)
	
	return maximizing_value

func min_value(s, alpha, beta):
	if not s.is_move_playable(): return s.get_h_value()
	
	var minimizing_value = INF
	for a in s.get_state_children():
		minimizing_value = min(minimizing_value, max_value(a,alpha,beta))
		if minimizing_value <= alpha: return minimizing_value
		
		beta = min(beta,minimizing_value)
	
	return minimizing_value




