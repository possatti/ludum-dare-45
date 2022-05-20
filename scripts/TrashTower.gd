extends Node2D

signal collapsed

const TRASH_NUGGET_SCENE = preload("res://nodes/TrashNugget.tscn")

const N_COLS = 7
const N_COLS_F = float(N_COLS)
const COL_SPACING = 20
const ROW_SPACING = 20

const INCLINATION_SPEED = 0.05 # radians per second.
var inclination = 0 # radians.
var has_collapsed = false

func _ready():
#	_magic_add_trash(7*12+2)
#	_magic_add_trash(12)
	pass

# This function is supposed to be used for debugging only.
func _magic_add_trash(n=1):
	for i in range(n):
		var trash = TRASH_NUGGET_SCENE.instance()
		add_child(trash)
	_rearrange()
	update() # Redraw.

func _rearrange():
	var pivot = Vector2.ZERO
	var middle_col = ceil(N_COLS_F / 2)
	for i in range(get_child_count()):
		var trash = get_child(i)
		var col = i % N_COLS
		var row = floor(i / N_COLS_F)

		var middle_col_dist = (col - middle_col) * COL_SPACING

		var row_inclination = inclination * row
		var trash_inclination = row_inclination + PI/2 # `PI/2` is vertical.

		if col == 0:
			var pivot_dx = cos(trash_inclination) * ROW_SPACING
			var pivot_dy = -sin(trash_inclination) * ROW_SPACING
			pivot += Vector2(pivot_dx, pivot_dy)

		trash.position = pivot + Vector2(cos(row_inclination) * middle_col_dist, -sin(row_inclination) * middle_col_dist)
		trash.rotation = row_inclination

func get_top_inclication():
	return get_rows_count() * inclination

func is_inclination_ok():
	var angle = get_top_inclication()
	if angle < - PI/2 or angle > PI/2:
		return false
	else:
		return true

# ======= OLD STUFF =======
#func _rearrange():
#	for i in range(get_child_count()):
#		var trash = get_child(i)
#		var col = i % N_COLS
#		var row = - floor(i / N_COLS)
#		trash.position = get_trash_position(row, col)
#		trash.rotation = get_trash_rotation(row)
#
#func get_trash_position(row, col):
#	var middle_col = ceil(N_COLS / 2) # FIXME: Do I still need this?
#	var middle_col_dist = (col - middle_col) * COL_SPACING
#
#	var row_inclination = inclination * row
#	var trash_inclination = inclination * row + PI/2 # `PI/2` is vertical.
#	var dist = row * ROW_SPACING
##	var col_dist = col * COL_SPACING
#
#	var x = cos(trash_inclination) * dist + cos(row_inclination) * middle_col_dist
#	var y = sin(trash_inclination) * dist + sin(row_inclination) * middle_col_dist
#	return Vector2(x, y)

#func get_trash_rotation(row):
#	return inclination * row
# =========================

func get_rows_count():
	return floor(get_child_count() / N_COLS_F) + 1

func get_height():
	return floor(get_child_count() / N_COLS_F) * ROW_SPACING

func _process(delta):
	if not has_collapsed:
		if Input.is_action_pressed("ui_right"):
			inclination += 0.1 * delta
		elif Input.is_action_pressed("ui_left"):
			inclination -= 0.1 * delta
		# For debugging.
		elif Input.is_action_pressed("ui_up"):
			_magic_add_trash(1)

		inclination += sign(inclination) * INCLINATION_SPEED * delta

		_rearrange()
		update()

		var max_repulsion = 300
		# Check if it collapsed now.
		if not is_inclination_ok():
			for trash in get_children():
				trash.apply_gravity = true
				trash.velocity = Vector2(rand_range(-max_repulsion,max_repulsion), rand_range(-max_repulsion,max_repulsion))
			has_collapsed = true
			emit_signal("collapsed")

func _draw():
	pass
#	draw_circle(Vector2.ZERO, 5, Color.blue)

#	draw_polyline([Vector2.ZERO, Vector2(cos(inclination)*300, -sin(inclination)*300)], Color.pink)

#	for i in range(get_rows_count()):
#		var point = get_trash_position(i, ceil(N_COLS / 2))
#		point.y *= -1
#		draw_circle(point, 2, Color.yellow)
