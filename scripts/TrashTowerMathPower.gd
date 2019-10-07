extends Node2D

# Bending:
#  - https://darioseyb.com/post/curvy-lines/
#  - https://math.stackexchange.com/questions/1860923/bending-a-line-segment
#  - https://www.desmos.com/calculator/99czjipvhu

# Calculating normals of a parametric curve:
#  - https://www.khanacademy.org/math/multivariable-calculus/integrating-multivariable-functions/line-integrals-in-vector-fields-articles/a/constructing-a-unit-normal-vector-to-curve

# Parallel curve of a parametrically given curve:
#  - https://en.wikipedia.org/wiki/Parallel_curve#Parallel_curve_of_a_parametrically_given_curve

const TRASH_NUGGET_SCENE = preload("res://nodes/TrashNugget.tscn")

const N_COLS = 7
const COL_SPACING = 20
const ROW_SPACING = 20

const INCLINATION_ACCELERATION = 0.1
var inclination = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	_magic_add_trash(7*12+2)

func _magic_add_trash(n=1):
	for i in range(n):
		var trash = TRASH_NUGGET_SCENE.instance()
		add_child(trash)
	_rearrange()
	update() # Redraw.

func _rearrange():
	var n_children = get_child_count()
	if n_children > 0:
		for i in range(n_children):
			var trash = get_child(i)
	#		var px = (i % N_COLS) * COL_SPACING
	#		var py = - (i / N_COLS * ROW_SPACING) # FIXME: Check if it's doing integer division.
	#		trash.position = Vector2(px, py)
			var col = i % N_COLS
			var row = - floor(i / N_COLS)
			trash.position = get_trash_position(row, col)

func get_trash_position(row, col):
	var middle_col = N_COLS / 2 # FIXME: Put on _ready.
	var tower_height = get_height()
	var d = (col - middle_col) * COL_SPACING
	var t = (row*ROW_SPACING) / tower_height
	return _foo(inclination, tower_height, t, d)

func get_height():
	return max(1, floor(get_child_count() / N_COLS) * ROW_SPACING)

# https://www.desmos.com/calculator/99czjipvhu
func _bending_equation(a, k, t):
	# This is a parametric function where `t` is the parameter, `a` and `k` are constants.
	# `a` is kind of a bending coefficient.
	# `k` is a number that grows or shrinks the whole thing.
	# `t` is "where" in the length of the line segment.
	return Vector2(k/a - k/a*cos(t*a), k/a*sin(t*a))

func _foo_x(a, k, t):
	if a == 0:
		return 0
	else:
		return k/a - k/a*cos(t*a)

func _foo_y(a, k, t):
	if a == 0:
		return k*t
	else:
		return k/a*sin(t*a)

func _foo_x_prime(a, k, t):
	return -sin(t*a)

func _foo_y_prime(a, k, t):
	return cos(t*a)

func _foo(a, k, t, d):
	var x_prime = _foo_x_prime(a, k, t)
	var y_prime = _foo_y_prime(a, k, t)
	var denominator = sqrt(pow(2,x_prime) + pow(2,y_prime))
	var x_component = _foo_x(a, k, t) + (d*y_prime) / denominator
	var y_component = _foo_y(a, k, t) + (d*x_prime) / denominator
	return Vector2(x_component, y_component)

func _process(delta):
	# Controls used for debugging.
	if Input.is_action_pressed("ui_right"):
		inclination += 1*delta
	elif Input.is_action_pressed("ui_left"):
		inclination -= 1*delta
	elif Input.is_action_pressed("ui_up"):
		_magic_add_trash(1)
	_rearrange()
	update()

func _draw():
	draw_circle(Vector2.ZERO, 5, Color.blue)

	if get_child_count() > 0:
		var tower_height = get_height()
		var n_rows = floor(get_child_count() / N_COLS)+1
		for row in range(n_rows):
			var t = (row*ROW_SPACING) / tower_height
			var point = _foo(inclination, tower_height, t, 0)
			point.y *= -1
			draw_circle(point, 2, Color.yellow)
		var points = []
		for i in range(tower_height):
			var t = i / tower_height
			var point = _foo(inclination, tower_height, t, 0)
			point.y *= -1
			points.append(point)
		draw_polyline(points, Color.pink)
