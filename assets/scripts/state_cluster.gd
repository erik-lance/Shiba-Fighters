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
var cur_calc_state = 0

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

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func load_ai(h,a):
	human_ai = h
	agent_ai = a

func set_manager(m): root_manager = m
func set_parent(p): parent = p
func set_depth(d): depth = d
func set_move(m): start_move = m
func set_start_state(s): start_state = s
func set_end_state(s): end_state = s

func new_state_cluster(start_state,m,p=self,d=depth+1):
	var new_cluster = load("res://scenes/state_cluster.tscn").instance()
	root_manager.add_child(new_cluster)
	cluster_children.append(new_cluster)
	
	new_cluster.set_parent(p)
	new_cluster.set_depth(d)
	new_cluster.set_move(m)

# Prepares a new move state in this direction
func prep_state(dets, m=-1):
	var new_state = load("res://scenes/state.tscn").instance()
	add_child(new_state)
	new_state.set_name('State '+states.size())
	
	states[cur_calc_state].prep_dets(dets, self,m)
	cur_calc_state += 1


func get_heuristic_value(): return h_value
