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

var defense = {
	guard = 1
}

var attacks = {
	bamboom = 10,
	rasengan = 25,
	senpu = 3,
	sudoku = 5
}

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

# Grabs how lethal each blow from an attack is
func get_lethality(atk=0):
	match(atk):
		0: return attacks.bamboom
		1: return attacks.rasengan
		2: return attacks.senpu
		3: return attacks.sudoku




