extends Node

var d = 7380
var pi = 3.1415926

### Orbital elements

var Bodies = ["Sun","Moon","Mercury","Venus","Mars","Jupiter","Saturn","Uranus","Neptune"]
var InnerBodies = ["Mercury","Venus","Mars"]

var Orbits = {
	
	"Sun": [
		0.0,
		0.0,
		282.9404 + 0.0000470935 * d,
		1.0,
		0.016709,
		356.0470 + 0.9856002585 * d
		],

	"Moon": [
		125.1228 - 0.0529538083 * d,
		5.1454,
		318.0634 + 0.1643573223 * d,
		60.2666,
		0.054900,
		115.3654 + 13.0649929509 * d
		],

	"Mercury": [
		48.3313,
		7.0047,
		29.1241,
		0.387098,
		0.205635,
		168.6562 + 4.0923344368 * d
	],

	"Venus": [
		76.6799 + 0.0000246590 * d,
		3.3946,
		54.8910 + 0.0000138374 * d,
		0.723330,
		0.006773,
		48.0052 + 1.6021302244 * d
	],

	"Mars": [
		49.5574 + 0.0000211081 * d,
		1.8497,
		286.5016 + 0.0000292961 * d,
		1.523688,
		0.093405,
		18.6021 + 0.5240207766 * d
	],

	"Jupiter": [
		100.4542 + 0.0000276854 * d,
		1.3030,
		273.8777 + 0.0000164505 * d,
		5.20256,
		0.048498,
		19.8950 + 0.0830853001 * d
	],

	"Saturn": [
		113.6634 + 0.000023898 * d,
		2.4886,
		339.3939 + 0.0000297661 * d,
		9.55475,
		0.055546,
		316.9670 + 0.0334442282 * d
	],

	"Uranus": [
		74.0005 + 0.000013978 * d,
		0.7733,
		96.6612 + 0.000030565 * d,
		19.18171,
		0.047318,
		142.5905 + 0.011725806 * d
	],

	"Neptune": [
		131.7806 + 0.000030173 * d,
		1.7700,
		272.8461,
		30.05826,
		0.008606,
		260.2471 + 0.005995147 * d
	],
	
}

func _ready():
	
	for body in Bodies:
		$ChooseBody.add_item(body)
	
	$ChooseBody.connect("item_selected", self, "on_item_selected")
	
	display_orbit_info("Sun")
	pass

func on_item_selected(id):
	display_orbit_info(str($ChooseBody.get_item_text(id)))

func display_orbit_info(body):
	$VarN.set_text(str(Orbits[body][0]))
	$Vari.set_text(str(Orbits[body][1]))
	$Varw.set_text(str(Orbits[body][2]))
	$Vara.set_text(str(Orbits[body][3]))
	$Vare.set_text(str(Orbits[body][4]))
	$VarM.set_text(str(Orbits[body][5]))
	pass

func find_sun_position(N,i,w,a,e,M):
	# Compute the eccentric anomaly of the sun
	var E = M + e*(180/pi) * sin(M) * (1.0 + e*cos(M))
	
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
	
	#print("xs=",xs)
	#print("ys=",ys)
	pass
	
func find_body_position(N,i,w,a,e,M):
	# Compute the eccentric anomaly of the body
	var E = 0
	if e < 0.05:
		E = M + e*(180/pi) * sin(M) * (1.0 + e*cos(M))
	else:
		var E0 = M
		var E1 = 0
		while (E1-E0) > 0.01:
			E1 = E0 - (E0 - e*(180/pi) * sin(E0) - M) / (1 - e*cos(E0))
		E = E1
		
	# Compute true anomaly
	var xv = a * (cos(E) - e)
	var yv = a * (sqrt(1.0 - e*e) * sin(E))
	var v = atan2(yv,xv)
	var r = sqrt(xv*xv + yv*yv)
	
	# Compute the body's position in space
	var xh = r * (cos(N) * cos(v+w) - sin(N) * sin(v+w) * cos(i))
	var yh = r * (sin(N) * cos(v+w) + cos(N) * sin(v+w) * cos(i))
	var zh = r * (sin(v+w) * sin(i))
	
	#print("xh=",xh)
	#print("yh=",yh)
	#print("zh=",zh)
	pass
