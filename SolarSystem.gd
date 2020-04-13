extends Node2D

var heliocentric = true

func _ready():
	pass

func centric_change(heliocentric):
	
	if heliocentric:
		heliocentric = true
	else:
		heliocentric = false
	
	for N in get_children():
		N.body_update(0,0,heliocentric)

func time_change():
	print("time change")
