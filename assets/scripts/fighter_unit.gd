extends Node2D

signal anim_done(anim_name)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func play_anim(anim_name):
	$AnimationPlayer.play(anim_name)

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name != 'default':
		emit_signal("anim_done",anim_name)
		$AnimationPlayer.play("default")
		$FX.clear_tile()
	else:
		print('done hehe')
