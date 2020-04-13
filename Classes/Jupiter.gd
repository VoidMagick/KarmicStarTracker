extends "res://Classes/Planets.gd"

func calculate_orbital_elements(d):
	
	var N = deg2rad(fposmod(100.4542 + 0.0000276854 * d, 360))
	var i = deg2rad(1.3030)
	var w = deg2rad(fposmod(273.8777 + 0.0000164505 * d, 360))
	var a = 5.20256
	var e = 0.048498
	var M = deg2rad(fposmod(19.8950 + 0.0830853001 * d, 360))

func calculate_perturbations():
	
	var Mj = M
	var Ms = deg2rad(fposmod(316.9670 + 0.0334442282 * d, 360))
	
	LongRSun = LongRSun + \
		-0.332 * sin(2*Mj - 5*Ms - deg2rad(67.6)) \
		-0.056 * sin(2*Mj - 2*Ms + deg2rad(21)) \
		+0.042 * sin(3*Mj - 5*Ms + deg2rad(21)) \
		-0.036 * sin(Mj - 2*Ms) \
		+0.022 * cos(Mj - Ms) \
		+0.023 * sin(2*Mj - 3*Ms + deg2rad(52)) \
		-0.016 * sin(Mj - 5*Ms - deg2rad(69))
