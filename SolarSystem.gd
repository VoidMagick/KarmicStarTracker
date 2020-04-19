extends Node2D

var heliocentric = true
var simspeed = 0

signal update_ui_time

func _ready():
	pass

func _physics_process(_delta):
	if simspeed != 0:
		TimeSelectionShared.DHour += simspeed
		time_change()
		emit_signal("update_ui_time")

################################################################################
## Functions for UI changes to the simulation and display

func centric_change(heliocentric):
	
	var d = TimeSelectionShared.d
	var ecl = TimeSelectionShared.ecl
	var helio = TimeSelectionShared.Heliocentric
	var zoom = TimeSelectionShared.zoom
		
	for N in get_children():
		N.body_update(d,ecl,helio,zoom)

func time_change():
	
	TimeSelectionShared.compute_d()
	TimeSelectionShared.calculate_lonsun()
	
	var d = TimeSelectionShared.d
	var ecl = TimeSelectionShared.ecl
	var helio = TimeSelectionShared.Heliocentric
	var zoom = TimeSelectionShared.zoom
	
	for N in get_children():
		N.body_update(d,ecl,helio,zoom)

#func zoom_change(zoom):
#
#	var helio = TimeSelectionShared.Heliocentric
#
#	for N in get_children():
#		N.position_body(helio,zoom)

func play_simulation(speed):
	simspeed = speed
	
func stop_simulation():
	simspeed = 0

