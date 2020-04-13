extends "res://Classes/Planets.gd"

func calculate_orbital_elements(d):
	
	var N = deg2rad(fposmod(113.6634 + 0.000023898 * d, 360))
	var i = deg2rad(2.4886)
	var w = deg2rad(fposmod(339.3939 + 0.0000297661 * d, 360))
	var a = 9.55475
	var e = 0.055546
	var M = deg2rad(fposmod(316.9670 + 0.0334442282 * d, 360))

func calculate_perturbations():
	
	var Mj = deg2rad(fposmod(19.8950 + 0.0830853001 * d, 360))
	var Ms = M
	
	LongRSun = LongRSun + \
		+0.812 * sin(2*Mj - 5*Ms - deg2rad(67.6)) \
		-0.229 * cos(2*Mj - 4*Ms - deg2rad(2)) \
		+0.119 * sin(Mj - 2*Ms - deg2rad(3)) \
		+0.046 * sin(2*Mj - 6*Ms - deg2rad(69)) \
		+0.014 * sin(Mj - 3*Ms + deg2rad(32))
	
	LatRSun = LatRSun + \
		-0.020 * cos(2*Mj - 4*Ms - deg2rad(2)) \
		+0.018 * sin(2*Mj - 6*Ms - deg2rad(49))
