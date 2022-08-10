extends Node2D

export (String, "MOVE", "DAMAGE", "REGEN_MANA", "REGEN_HP") var tile_type

export (bool) var top_left
export (bool) var top_center
export (bool) var top_right

export (bool) var mid_left
export (bool) var mid_center
export (bool) var mid_right

export (bool) var bot_left
export (bool) var bot_center
export (bool) var bot_right

# Tile Type
func set_type(t=0): tile_type = t

func set_tile(t,d):
	match(t):
		0: top_left = d
		1: top_center = d
		2: top_right = d
		3: mid_left = d
		4: mid_center = d
		5: mid_right = d
		6: bot_left = d
		7: bot_center = d
		8: bot_right = d
		_: print("Missing tile!")

func get_tile(t):
	match(t):
		0: return top_left 
		1: return top_center
		2: return top_right
		3: return mid_left
		4: return mid_center
		5: return mid_right
		6: return bot_left
		7: return bot_center
		8: return bot_right
		_: 
			print("Missing Tile!")
			return null

func get_tiles():
	var tiles = []
	
	if top_left: tiles.append(0)
	if top_center: tiles.append(1)
	if top_right: tiles.append(2)
	if mid_left: tiles.append(3)
	if mid_center: tiles.append(4)
	if mid_right: tiles.append(5)
	if bot_left: tiles.append(6)
	if bot_center: tiles.append(7)
	if bot_right: tiles.append(8)
	
	if tiles.size() == 0: return null
	
	return tiles

# Setters
func set_top_left(d=true): top_left = d
func set_top_center(d=true): top_center = d
func set_top_right(d=true): top_right = d

func set_mid_left(d=true): mid_left = d
func set_mid_center(d=true): mid_center = d
func set_mid_right(d=true): mid_right = d

func set_bot_left(d=true): bot_left = d
func set_bot_center(d=true): bot_center = d
func set_bot_right(d=true): bot_right = d


# Getters
func get_top_left(): return top_left
func get_top_center(): return top_center
func get_top_right(): return top_right

func get_mid_left(): return mid_left
func get_mid_center(): return mid_center
func get_mid_right(): return mid_right

func get_bot_left(): return bot_left
func get_bot_center(): return bot_center
func get_bot_right(): return bot_right
