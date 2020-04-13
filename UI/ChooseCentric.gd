extends OptionButton

signal centric_change(heliocentric)

func _ready():
	pass

func _on_ChooseCentric_item_selected(id):
	if not id:
		print("Heliocentric")
		emit_signal("centric_change",true)
	else:
		print("Geocentric")
		emit_signal("centric_change",false)
