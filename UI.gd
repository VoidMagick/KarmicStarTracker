extends Control

func _ready():
	pass # Replace with function body.

func _on_OptionButton_item_selected(id):
	if not id:
		print("heliocentic")
		## Set global heliocentric value to true
		## Redraw the solar system
	elif id:
		print("geocentric")
		## Set global heliocentric value to false
		## Redraw the solar system
