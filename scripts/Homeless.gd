extends Node2D

func _ready():
	pass

func play_throw_animation():
	$ThrowAnimation.frame = 0
	$ThrowAnimation.visible = true
	$ThrowAnimation.play("throw")

func _process(delta):
#	if Input.is_action_just_pressed("ui_up"):
#		play_throw_animation()
	pass
