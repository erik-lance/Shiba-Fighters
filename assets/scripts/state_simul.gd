extends Node2D

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

func prep_dets(dets):
	cur_state.player_pos_x = dets.player_pos_x
	cur_state.player_pos_y = dets.player_pos_y
	cur_state.self_pos_x = dets.self_pos_x
	cur_state.self_pos_y = dets.self_pos_y
	cur_state.player_hp = dets.player_hp
	cur_state.player_mp = dets.player_mp
	cur_state.self_hp = dets.self_hp
	cur_state.self_mp = dets.self_mp

#
#
# CALCULATION TOOLS
#
#
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
