tool
extends Node2D

const RADIUS = 200
const COLOR = Color.yellow

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _draw():
	draw_circle(Vector2.ZERO, RADIUS, COLOR)
