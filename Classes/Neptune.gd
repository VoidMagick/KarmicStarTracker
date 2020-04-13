extends "res://Classes/Planets.gd"

func calculate_orbital_elements(d):
	
	var N = deg2rad(fposmod(131.7806 + 0.000030173 * d, 360))
	var i = deg2rad(1.7700)
	var w = deg2rad(272.8461)
	var a = 30.05826
	var e = 0.008606
	var M = deg2rad(fposmod(260.2471 + 0.005995147 * d, 360))
