extends Node2D

signal hit_hp(hp)
signal use_mp(mp)

var side

var max_hp
var cur_hp

var max_mp
var cur_mp

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func ready_fighter(side=0, hp=100, mp=100):
	max_hp = hp
	cur_hp = hp
	
	max_mp = mp
	cur_mp = mp
	
	side = side

func regen_mp(mp):
	cur_mp +=  mp
	if cur_mp > max_mp: cur_mp = max_mp

func take_damage(dmg):
	cur_hp -= dmg
	if cur_hp < 0: cur_hp = 0
	emit_signal('hit_hp', cur_hp)

func use_mp(mp):
	cur_mp -= mp
	emit_signal('use_mp', cur_mp)
	
