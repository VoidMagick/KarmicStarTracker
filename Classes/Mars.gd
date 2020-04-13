extends "res://Classes/Planets.gd"

func calculate_orbital_elements(d):
	
	var N = deg2rad(fposmod(49.5574 + 0.0000211081 * d, 360))
	var i = deg2rad(1.8497)
	var w = deg2rad(fposmod(286.5016 + 0.0000292961 * d, 360))
	var a = 1.523688
	var e = 0.093405
	var M = deg2rad(fposmod(18.6021 + 0.5240207766 * d, 360))
