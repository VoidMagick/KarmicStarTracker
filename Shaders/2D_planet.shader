shader_type canvas_item;

// Adjust these artistically
uniform vec3 planetColor = vec3(0.1,1.0,0.2);
uniform vec3 outline = vec3(1.0,1.0,1.0);
uniform float planetRadius = 0.49;

void fragment(){
	vec3 finalcolor = vec3(0.0);
	float finalalpha = 1.0;
	
	// Position of each pixel from the center as a percentage
	float pct = distance(UV,vec2(0.5));
	
	// Drawing the basic circle
	float planet = smoothstep(planetRadius+0.005,planetRadius-0.005,pct);
	finalcolor += vec3(planet)*planetColor;
	finalalpha = planet;
	
	// Border circle color
	float border = smoothstep(planetRadius-0.05,planetRadius+0.005,pct)*0.8;
	finalcolor += vec3(border)*outline;
	
	// Color that baby up
	COLOR = vec4(finalcolor,finalalpha);
}