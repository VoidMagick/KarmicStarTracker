extends "res://Classes/Planets.gd"

func calculate_orbital_elements(d):
	
	var N = deg2rad(fposmod(74.0005 + 0.000013978 * d, 360))
	var i = deg2rad(0.7733)
	var w = deg2rad(fposmod(96.6612 + 0.000030565 * d, 360))
	var a = 19.18171
	var e = 0.047318
	var M = deg2rad(fposmod(142.5905 + 0.011725806 * d, 360))

func calculate_perturbations():
	
	var Mj = deg2rad(fposmod(19.8950 + 0.0830853001 * d, 360))
	var Ms = deg2rad(fposmod(316.9670 + 0.0334442282 * d, 360))
	var Mu = M
	
	LongRSun = LongRSun + \
		+0.040 * sin(Ms - 2*Mu + deg2rad(6)) \
		+0.035 * sin(Ms - 3*Mu + deg2rad(33)) \
		-0.015 * sin(Mj - Mu + deg2rad(20))
