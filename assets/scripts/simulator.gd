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

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func prep_sim(dets):
	cur_dets = dets

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
	pass
	

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
