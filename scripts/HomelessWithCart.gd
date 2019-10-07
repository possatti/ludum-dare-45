extends Area2D

signal trash_amount_changed

const ACCELERATION = 80
var speed = 300 # Original: 40
const WHEEL_SPEED_RATIO = 60.0
const WALK_SPEED_RATIO = 50.0

func _ready():
	$ThrowAnimation.visible = false
#	$TrashTower.inclination = -0.01
	pass # Replace with function body.

func play_throw_animation():
	$ThrowAnimation.frame = 0
	$ThrowAnimation.visible = true
	$ThrowAnimation.play("throw")

func _process(delta):
	if Input.is_action_pressed("ui_right"):
		speed += ACCELERATION * delta
	elif Input.is_action_pressed("ui_left"):
		speed -= ACCELERATION * delta
#		print('speed:', speed)

	var normalized_speed = speed * delta

	# Adjust animatio speed so it will look like he is really walking.
	var walk_speed_scale = speed / WALK_SPEED_RATIO
	if walk_speed_scale >= 0:
		$WalkAnimation.speed_scale = walk_speed_scale
		$WalkAnimation.play("walk", false)
	else:
		$WalkAnimation.speed_scale = - walk_speed_scale
		$WalkAnimation.play("walk", true)

	# Rotate wheel.
	$Wheel.rotate(normalized_speed / WHEEL_SPEED_RATIO)

	# Move.
	position.x += normalized_speed

func _on_HomelessWithCart_area_entered(area):
	if area.is_in_group("trash_bin") and not area.is_open and not $TrashTower.has_collapsed:
		area.open()
		play_throw_animation()
		if $TrashTower.get_child_count() == 0:
			$TrashTower._magic_add_trash(50)
			$TrashTower.inclination = -0.01
		else:
			$TrashTower._magic_add_trash(4)
		emit_signal("trash_amount_changed", $TrashTower.get_child_count())
