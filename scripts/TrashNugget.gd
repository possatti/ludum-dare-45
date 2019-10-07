tool
extends Node2D

# https://www.buzzfeed.com/angelameiquan/beautiful-color-palettes-inspired-by-nyc-garbage
const COLOR_POOL = [
	# https://img.buzzfeed.com/buzzfeed-static/static/2014-09/25/14/enhanced/webdr04/longform-original-3370-1411668237-18.jpg?downsize=800:*&output-format=auto&output-quality=auto
	Color("#77171b"),
	Color("#fea048"),
	Color("#ae9b7d"),
	Color("#ced2d5"),

	# https://img.buzzfeed.com/buzzfeed-static/static/2014-09/25/12/enhanced/webdr04/longform-original-21993-1411660920-14.jpg?downsize=700%3A%2A&output-quality=auto&output-format=auto
	Color("#dbaaa6"),
	Color("#b0d8c1"),
#	Color("#484b47"), # black
#	Color("#f3e0d4"), # white

	# https://img.buzzfeed.com/buzzfeed-static/static/2014-09/25/13/enhanced/webdr02/longform-original-24943-1411667866-17.jpg?downsize=700%3A%2A&output-quality=auto&output-format=auto
	Color("#18310b"), # green
	Color("#ffcf02"), # yellow
	Color("#5f8ecc"), # blue

	# https://img.buzzfeed.com/buzzfeed-static/static/2014-09/25/13/enhanced/webdr10/longform-original-6790-1411667313-30.jpg?downsize=800:*&output-format=auto&output-quality=auto
	Color("#5f402d"), # brown
	Color("#e2c576"), # yellow
#	Color("#bcc8d6"), # white
	Color("#202322"), # black
#	Color("#"), #
]
const PI2 = PI * 2
const JITTER_MAGNITITUDE = 5

const N_POINTS = 10
const RADIUS = 10
var polygon_points = []

var velocity = Vector2.ZERO
var apply_gravity = false
const GRAVITY = 10

export (Color) var color = null

func _ready():
	var color_idx = randi() % len(COLOR_POOL)
#	color = Color("#fea048")
	color = COLOR_POOL[color_idx]
	var rad_segment = PI2 / N_POINTS
	for i in range(N_POINTS):
		var radial_offset = rand_range(-1, 1) * JITTER_MAGNITITUDE
		var angle_rad = rad_segment * i
		var px = cos(angle_rad) * (RADIUS + radial_offset)
		var py = sin(angle_rad) * (RADIUS + radial_offset)
		polygon_points.append(Vector2(px, py))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if apply_gravity:
		velocity.y += GRAVITY
	position += velocity * delta

func _draw():
	pass
#	draw_circle(Vector2.ZERO, RADIUS, Color(1,0,0,0.2))
	draw_colored_polygon(polygon_points, color)

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
