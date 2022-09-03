extends Node2D

# This holds the 3 states to ensure the sequence
# Each state cluster will be laid out after that.

var root_manager = null
var parent = null
var depth = 0

var children = []

var h_value = 0
var start_move = -1

var sequence = {
	move_1 = null,
	move_2 = null,
	move_3 = null
}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_manager(m): root_manager = m
func set_parent(p): parent = p
func set_depth(d): depth = d
func set_move(m): start_move = m

func new_state_cluster(m,p=self,d=depth+1):
	var new_cluster = load("res://scenes/state_cluster.tscn").instance()
	root_manager.add_children(new_cluster)
	new_cluster.set_parent(p)
	new_cluster.set_depth(d)
	new_cluster.set_move(m)
	

func get_heuristic_value(): return h_value
