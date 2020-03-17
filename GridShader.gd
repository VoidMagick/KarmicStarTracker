extends Node2D

# Variables to adjust the visuals of the grid
var GridColor = Color(1.0,1.0,1.0,0.3)
var GridRadius = 800
var RSteps = 50
var ThetaSteps = 15

func _draw():
	
	# Draw the grid circles
	for n in range(50,GridRadius,RSteps):
		draw_arc(Vector2(0,0),n,0,2*PI,PI*n,GridColor,1.0,true)
	
	# Draw the grid lines
	for theta in range(0,360,ThetaSteps):
		var xpos = GridRadius * cos(deg2rad(theta))
		var ypos = GridRadius * sin(deg2rad(theta))
		print("x=",xpos," y=",ypos)
		draw_line(Vector2(0,0),Vector2(xpos,ypos),GridColor,1.0,true)
	
	pass
