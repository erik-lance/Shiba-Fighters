extends Node2D

onready var arena_manager = $ArenaManager
onready var deck_manager = $DeckManager
onready var screen = $StrategyScreen
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

# Called when the node enters the scene tree for the first time.
func _ready():
	arena_manager.connect("arena_finished",self,'_on_arena_loaded')
	arena_manager.connect("player_finished",self,'player_done')
	arena_manager.connect("enemy_finished",self,'enemy_done')
	
	arena_manager.prepare_tester()
	screen.set_deck(deck_manager.get_shiba_cards())
	anim.play("strat_screen_open")
	screen.connect("begin",self,'_on_battle_begin')



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func _on_arena_loaded(player,enemy):
	fighter.player = player
	fighter.enemy = enemy
	print('Arena has successfully loaded!')

func _on_battle_begin(cards):
	player_cards = cards
	anim.play("strat_screen_close")
	battle_director()

func battle_director():
	print(fighter.player)
	fighter.player.get_child(0).play_anim(player_cards[cur_turn].get_anim_name())
	pass

func player_done(anim_name):
	pass

func enemy_done(anim_name):
	pass

func animation_done():
	pass
