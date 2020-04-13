extends Node2D

var heliocentric = true

func _ready():
	pass

func centric_change(heliocentric):
	
	var d = TimeSelectionShared.d
	var ecl = TimeSelectionShared.ecl
	var helio = TimeSelectionShared.Heliocentric
		
	for N in get_children():
		N.body_update(d,ecl,helio)

func time_change():
	
	TimeSelectionShared.compute_d()
	
	var d = TimeSelectionShared.d
	var ecl = TimeSelectionShared.ecl
	var helio = TimeSelectionShared.Heliocentric
	
	for N in get_children():
		N.body_update(d,ecl,helio)
