extends "res://Classes/Planets.gd"

func calculate_orbital_elements(d):
	
	N = deg2rad(fposmod(76.6799 + 0.0000246590 * d, 360))
	i = deg2rad(3.3946)
	w = deg2rad(fposmod(54.8910 + 0.0000138374 * d, 360))
	a = 0.723330
	e = 0.006773
	M = deg2rad(fposmod(48.0052 + 1.6021302244 * d, 360))
