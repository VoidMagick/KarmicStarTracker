extends "res://Classes/Planets.gd"

func calculate_orbital_elements(d):
	
	N = deg2rad(fposmod(131.7806 + 0.000030173 * d, 360))
	i = deg2rad(1.7700)
	w = deg2rad(272.8461)
	a = 30.05826
	e = 0.008606
	M = deg2rad(fposmod(260.2471 + 0.005995147 * d, 360))
