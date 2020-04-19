extends "res://Classes/Planets.gd"

func calculate_orbital_elements(d):
	
	N = deg2rad(48.3313)
	i = deg2rad(7.0047)
	w = deg2rad(29.1241)
	a = 0.387098
	e = 0.205635
	M = deg2rad(fposmod(168.6562 + 4.0923344368 * d, 360))
