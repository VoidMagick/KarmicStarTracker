extends "res://Classes/Planets.gd"

func calculate_orbital_elements(d):
	
	var N = deg2rad(48.3313)
	var i = deg2rad(7.0047)
	var w = deg2rad(29.1241)
	var a = 0.387098
	var e = 0.205635
	var M = fposmod(168.6562 + 4.0923344368 * d, 360)
