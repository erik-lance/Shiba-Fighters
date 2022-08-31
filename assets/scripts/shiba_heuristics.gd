extends Node2D


# We will use a weight based system to calculate the heuristics
# Call a certain function to increase heuristics on a certain set of moves
# E.g. Defensive moves add 1 to their weights

var moves = {
	up = 1,
	down = 1,
	left = 1,
	right = 1
}

var regen = {
	mana = 4
}

var regen_amt = {
	mana = 15
}

var defense = {
	guard = 8
}

var attacks = {
	bamboom = 10,
	rasengan = 25,
	senpu = 3,
	sudoku = 5
}

var attacks_cost = {
	bamboom = 45,
	rasengan = 45,
	senpu = 15,
	sudoku = 20
}

var dmg_proximity = {
	n_0 = 5,
	n_1 = 12,
	n_2 = 5,
	n_3 = 15,
	n_4 = 15,
	n_5 = 15,
	n_6 = 5,
	n_7 = 12,
	n_8 = 5
}

var burst_limit = 35

# Grabs tiles where can be attacked by said attack
func get_grid_atk(atk=0):
	match(atk):
		0:
			return [false,true,false,
					true,true,true,
					false,true,false]
		1:
			return [false,false,false,
					true,false,true,
					false,false,false]
		2:
			return [true,true,true,
					true,false,true,
					true,true,true]
		3:
			return [true,false,true,
					false,true,false,
					true,false,true]
		_:
			print('Invalid Move!')
			return null

# 0-3 Move U/L/D/R
# 4 Regen
# 5 Guard
# 6 Perfect Guard
# 7 Bamboom
# 8 Rasengan
# 9 Senpu
# 10 Sudoku
# 11 Burst Limit
func is_move_playable(move=0,cost=0):
	match(move):
		0: return true
		1: return true
		2: return true
		3: return true
		4: return true
		5: return true
		6: if cost>= get_regen(0,1): return true
		7: if cost>= get_lethality(0,1): return true
		8: if cost>= get_lethality(1,1): return true
		9: if cost>= get_lethality(2,1): return true
		10: if cost>= get_lethality(3,1): return true
		11: if cost>= 80: return true
	return false

func get_move_type(t=-1):
	if t == -1: return null
	elif t >= 0 and t <= 3: return 0
	elif t == 4: return 1
	elif t >= 5 and t <= 6: return 2
	else: return 3
	

# Grabs how lethal each blow from an attack is
func get_lethality(atk=0,cost=0):
	if cost==0:
		match(atk):
			0: return attacks.bamboom
			1: return attacks.rasengan
			2: return attacks.senpu
			3: return attacks.sudoku
	else:
		match(atk):
			0: return attacks_cost.bamboom
			1: return attacks_cost.rasengan
			2: return attacks_cost.senpu
			3: return attacks_cost.sudoku

func get_defense(def=0):
	match(def):
		0: return defense.guard

func get_regen(reg=0, cost=0):
	if cost == 0:
		match(reg):
			0: return regen.mana
	else:
		match(reg):
			0: return regen_amt.mana

