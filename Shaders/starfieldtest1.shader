shader_type canvas_item;

// Shader constants
uniform int iterations = 17;
uniform float formuparam = 0.53;

uniform int volsteps = 20;
uniform float stepsize = 0.1;

uniform float zoom = 0.4;
uniform float tile = 0.85;
uniform float speed = 0.01;

uniform float brightness = 0.0015;
uniform float darkmatter = 0.3;
uniform float distfading = 0.73;
uniform float saturation = 0.85; 

void fragment(){
	vec3 finalcolor = vec3(0.0);
	float finalalpha = 1.0;
	
	//get coords and direction
	vec2 uv = UV;
	vec3 dir = vec3(uv*zoom,1.0);
	float time = TIME * speed + 0.25;
	
	//mouse rotation
	float a1=0.7;
	float a2=0.8;
	mat2 rot1 = mat2(vec2(cos(a1),sin(a1)),vec2(-sin(a1),cos(a1)));
	mat2 rot2 = mat2(vec2(cos(a2),sin(a2)),vec2(-sin(a2),cos(a2)));
	dir.xz*=rot1;
	dir.xy*=rot2;
	vec3 from=vec3(1.,.5,0.5);
	from+=vec3(time*2.,time,-2.);
	from.xz*=rot1;
	from.xy*=rot2;
	
	//volumetric rendering
	float s=0.1,fade=1.;
	vec3 v=vec3(0.);
	for (int r=0; r<volsteps; r++) {
		vec3 p=from+s*dir*.5;
		p = abs(vec3(tile)-mod(p,vec3(tile*2.))); // tiling fold
		float pa,a=pa=0.;
		for (int i=0; i<iterations; i++) { 
			p=abs(p)/dot(p,p)-formuparam; // the magic formula
			a+=abs(length(p)-pa); // absolute sum of average change
			pa=length(p);
		}
		float dm=max(0.,darkmatter-a*a*.001); //dark matter
		a*=a*a; // add contrast
		if (r>6) fade*=1.-dm; // dark matter, don't render near
		//v+=vec3(dm,dm*.5,0.);
		v+=fade;
		v+=vec3(s,s*s,s*s*s*s)*a*brightness*fade; // coloring based on distance
		fade*=distfading; // distance fading
		s+=stepsize;
	}
	v=mix(vec3(length(v)),v,saturation); //color adjust
	
	// Color that baby up
	COLOR = vec4(v*0.01,1.0);
}