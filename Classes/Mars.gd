extends "res://Classes/Planets.gd"

func calculate_orbital_elements(d):
	
	N = deg2rad(fposmod(49.5574 + 0.0000211081 * d, 360))
	i = deg2rad(1.8497)
	w = deg2rad(fposmod(286.5016 + 0.0000292961 * d, 360))
	a = 1.523688
	e = 0.093405
	M = deg2rad(fposmod(18.6021 + 0.5240207766 * d, 360))
