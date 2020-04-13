extends "res://Classes/Planets.gd"

func calculate_orbital_elements(d):
	
	var N = deg2rad(fposmod(76.6799 + 0.0000246590 * d, 360))
	var i = deg2rad(3.3946)
	var w = deg2rad(fposmod(54.8910 + 0.0000138374 * d, 360))
	var a = 0.723330
	var e = 0.006773
	var M = deg2rad(fposmod(48.0052 + 1.6021302244 * d, 360))
