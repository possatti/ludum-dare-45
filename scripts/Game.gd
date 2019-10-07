extends Node

const HOUSE_SCENE = preload("res://nodes/House.tscn")
const TRASH_BIN_SCENE = preload("res://nodes/TrashBin.tscn")

const TRASH_NUGGET_PRICE = 0.03
onready var score_label = $HUD/Score

onready var camera_node = $Camera2D
var zoom_factor = 2

onready var sun_initial_position = $Sun.position
onready var player_initial_position = $HomelessWithCart.position

onready var game_over_overlay = $HUD/GameOverOverlay
var _is_game_over = false

const SPAWN_DIST_THRESH = 1000
var _last_spawn_x = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	$HomelessWithCart/TrashTower.connect("collapsed", self, "game_over")

func game_over():
	_is_game_over = true
	game_over_overlay.visible = true

const HOUSE_SPAWN_OFFSET_X = 800
func spawn_house_and_trash_bin():
	var house = HOUSE_SCENE.instance()
	var trash_bin = TRASH_BIN_SCENE.instance()
	var base_x = get_viewport().size.x * zoom_factor / 2 + $HomelessWithCart.position.x
	var base_y = get_viewport().size.y
	_last_spawn_x = base_x
	house.position = Vector2(base_x + HOUSE_SPAWN_OFFSET_X, base_y)
	trash_bin.position = Vector2(base_x + HOUSE_SPAWN_OFFSET_X + 520, base_y)
	add_child_below_node($Sun, trash_bin)
	add_child_below_node($Sun, house)

func _process(delta):
	camera_node.position.x = $HomelessWithCart.position.x
	camera_node.position.y = get_viewport().size.y - get_viewport().size.y*zoom_factor/2
	camera_node.zoom = Vector2.ONE * zoom_factor

	$Sun.position = sun_initial_position + $HomelessWithCart.position - player_initial_position

	if _is_game_over and Input.is_action_just_pressed("ui_restart"):
		get_tree().reload_current_scene()

	var last_spawn_dist = $HomelessWithCart.position.x - _last_spawn_x
	if last_spawn_dist > SPAWN_DIST_THRESH:
		spawn_house_and_trash_bin()

func _on_HomelessWithCart_trash_amount_changed(n_trash_nuggets):
#	score_label.text = str(TRASH_NUGGET_PRICE * n_trash_nuggets)
	if not _is_game_over:
		score_label.text = "%.2f" % (TRASH_NUGGET_PRICE * n_trash_nuggets)
