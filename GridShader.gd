extends Node2D

func _ready():
	pass

func toggle_grid(show):
	if show:
		show()
	else:
		hide()
