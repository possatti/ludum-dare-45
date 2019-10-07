extends Area2D

signal opened

var is_open = false

func _ready():
	pass

#func _on_TrashBin_area_entered(area):
#	if area.is_in_group("homeless"):
#		open()

func open():
	$LidOnTop.visible = false
	$LidOpen.visible = true
	is_open = true
	emit_signal("opened")
