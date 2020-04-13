extends "res://Classes/CelestialBody.gd"

func calculate_orbital_elements(d):
	
	N = 0.0
	i = 0.0
	w = deg2rad(282.9404 + 0.0000470935 * d)
	a = 1.0
	e = 0.016709
	M = deg2rad(fposmod(356.0470 + 0.9856002585 * d, 360))

func calculate_position():
	
	## Find Sun Position Relative to Earth
	
	# Compute the eccentric anomaly of the sun
	var E = M + e * sin(M) * (1.0 + e*cos(M))
	
	# Compute true anomaly
	var xv = cos(E) - e
	var yv = sqrt(1.0 - e*e) * sin(E)
	var v = atan2(yv,xv)
	var r = sqrt(xv*xv + yv*yv)
		
	# Compute longitude
	var lonsun = v + w
	
	# Convert to ecliptic rectangular coordinates
	var xs = r * cos(lonsun)
	var ys = r * sin(lonsun)
	
	PosREarth = Vector3(xs,ys*cos(ecl),ys*sin(ecl))
	PosRSun = Vector3(0,0,0)
