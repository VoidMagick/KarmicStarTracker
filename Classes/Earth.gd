extends "res://Classes/CelestialBody.gd"

func calculate_orbital_elements(d):
	
	N = 0.0
	i = 0.0
	w = deg2rad(fposmod(282.9404 + 0.0000470935 * d, 360))
	a = 1.0
	e = 0.016709
	M = deg2rad(fposmod(356.0470 + 0.9856002585 * d, 360))

func calculate_position():
	
	# Convert to ecliptic rectangular coordinates
	lonsun = TimeSelectionShared.lonsun
	rs = TimeSelectionShared.rs
	var xe = -rs * cos(lonsun)
	var ye = -rs * sin(lonsun)
	
	PosRSun = Vector3(xe,ye,0)
	PosREarth = Vector3(0,0,0)
