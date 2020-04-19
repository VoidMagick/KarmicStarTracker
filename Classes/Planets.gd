extends "res://Classes/CelestialBody.gd"

func calculate_position():
	
	# Compute the eccentric anomaly of the body
	var E = 0
	if e < 0.05:
		E = M + e * sin(M) * (1.0 + e*cos(M))
	else:
		var E0 = M
		var E1 = 0
		while abs(E0-E1) > 0.0001:
			E0 = E1
			E1 = E0 - (E0 - e * sin(E0) - M) / (1 - e*cos(E0))
		E = E1;
	
	# Compute true anomaly
	var xv = a * (cos(E) - e)
	var yv = a * (sqrt(1.0 - e*e) * sin(E))
	var v = atan2(yv,xv)
	var r = sqrt(xv*xv + yv*yv)
	
	# Compute the body's position in space
	var xh = r * (cos(N) * cos(v+w) - sin(N) * sin(v+w) * cos(i))
	var yh = r * (sin(N) * cos(v+w) + cos(N) * sin(v+w) * cos(i))
	var zh = r * (sin(v+w) * sin(i))
	
	LongRSun = atan2(yh,xh)
	LatRSun = atan2(zh,sqrt(xh*xh+yh*yh))
	
	consider_perturbations()
	
	# Re-compute position considering perturbations
	xh = r * cos(LongRSun) * cos(LatRSun)
	yh = r * sin(LongRSun) * cos(LatRSun)
	zh = r * sin(LatRSun)
	
	PosRSun = Vector3(xh,yh,zh)
	
	# Calculate sun's position and compare
	lonsun = TimeSelectionShared.lonsun
	rs = TimeSelectionShared.rs
	var xs = rs * cos(lonsun)
	var ys = rs * sin(lonsun)
	
	var xg = xh + xs
	var yg = yh + ys
	var zg = zh
	
	PosREarth = Vector3(xg,yg,zg)
	
	
