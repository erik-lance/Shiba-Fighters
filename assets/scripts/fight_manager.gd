extends Node2D

onready var arena_manager = $ArenaManager
onready var deck_manager = $DeckManager
onready var screen = $StrategyScreen
onready var ai_manager = $AIManager
onready var anim = $AnimationPlayer

var round_num = 0

var max_turn = 3
var cur_turn = 0

var player_cards = null
var enemy_cards = null


var fighter = {
	player = null,
	enemy = null
}

var cur_state = {
	player_pos_x = 0,
	player_pos_y = 1,
	self_pos_x = 7,
	self_pos_y = 2,
	player_hp = 100,
	player_mp = 100,
	self_hp = 100,
	self_mp = 100
}

var player_hp = 0
var player_mp = 0
var enemy_hp = 0
var enemy_mp = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	arena_manager.connect("arena_finished",self,'_on_arena_loaded')
	arena_manager.connect("player_finished",self,'player_done')
	arena_manager.connect("enemy_finished",self,'enemy_done')
	
	arena_manager.load_arena()
	screen.set_deck(deck_manager.get_shiba_cards())
	anim.play("strat_screen_open")
	screen.connect("begin",self,'_on_battle_begin')

# Binds the player and enemy onto the arena.
func _on_arena_loaded(player,enemy):
	fighter.player = player
	fighter.enemy = enemy
	print('Arena has successfully loaded!')
	
	ai_manager.set_cur_state(cur_state)
#	ai_manager.prepare_ai()
	ai_manager.decide_cards()
	print("Cards have been decided")
	print("I think player will play: ")
	print(ai_manager.get_moves_human())
	print("But I will play: ")
	print(ai_manager.get_moves_agent())

# Executes when start button is pressed.
func _on_battle_begin(cards):
	player_cards = cards
	anim.play("strat_screen_close")
	
	battle_director()

func battle_director():
	screen.prep_cur_stats(player_hp, player_mp)
	
	# Forces player to start their first animation
	fighter.player.get_child(0).play_anim(player_cards[cur_turn].get_anim_name())

# Player finishes animation
func player_done(anim_name):
	pass

# Enemy finishes animation
func enemy_done(anim_name):
	pass

func animation_done():
	pass
