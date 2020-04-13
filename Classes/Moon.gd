extends "res://Classes/CelestialBody.gd"

func calculate_orbital_elements(d):
	
	var N = deg2rad(fposmod(125.1228 - 0.0529538083 * d, 360))
	var i = deg2rad(5.1454)
	var w = deg2rad(fposmod(318.0634 + 0.1643573223 * d, 360))
	var a = 60.2666
	var e = 0.054900
	var M = deg2rad(fposmod(115.3654 + 13.0649929509 * d, 360))

func calculate_position(d,ecl):
	
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
			#print("E0=",str(E0)," E1=",str(E1))
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
	
	PosREarth = Vector3(xh,yh,zh)
	
	LongREarth = atan2(yh,xh)
	LatREarth = atan2(zh,sqrt(xh*xh+yh*yh))
	
	consider_perturbations()

func consider_perturbations():
	
	var Ms = deg2rad(fposmod(356.0470 + 0.9856002585 * d, 360))
	var Mm = M
	var Nm = N
	var ws = deg2rad(282.9404 + 0.0000470935 * d)
	var wm = w
	
	var Ls = Ms + ws;		# Mean longitude of the sun (Ns=0)
	var Lm = Mm + wm + Nm	# Mean longitude of the moon
	var D = Lm - Ls			# Mean elongation of the moon
	var F = Lm - Nm			# Argument of latitude for the moon
	
	LongREarth = LongREarth + \
		deg2rad(-1.274) * sin(Mm - 2*D) + \
		deg2rad(+0.658) * sin(2*D) +  \
		deg2rad(-0.186) * sin(Ms) + \
		deg2rad(-0.059) * sin(2*Mm - 2*D) + \
		deg2rad(-0.057) * sin(Mm - 2*D + Ms) + \
		deg2rad(+0.053) * sin(Mm + 2*D) + \
		deg2rad(+0.046) * sin(2*D - Ms) + \
		deg2rad(+0.041) * sin(Mm - Ms) + \
		deg2rad(-0.035) * sin(D) + \
		deg2rad(-0.031) * sin(Mm + Ms) + \
		deg2rad(-0.015) * sin(2*F - 2*D) + \
		deg2rad(+0.011) * sin(Mm - 4*D)
	
	LatREarth = LatREarth + \
		deg2rad(-0.173) * sin(F - 2*D) + \
		deg2rad(-0.055) * sin(Mm - F - 2*D) + \
		deg2rad(-0.046) * sin(Mm + F - 2*D) + \
		deg2rad(+0.033) * sin(F + 2*D) + \
		deg2rad(+0.017) * sin(2*Mm + F)
