shader_type canvas_item;

float random (in vec2 _st) {
    return fract(sin(dot(_st.xy,vec2(12.9898,78.233)))*43758.5453123);
}

// Based on Morgan McGuire @morgan3d
// https://www.shadertoy.com/view/4dS3Wd
float noise (in vec2 _st) {
    vec2 i = floor(_st);
    vec2 f = fract(_st);

    // Four corners in 2D of a tile
    float a = random(i);
    float b = random(i + vec2(1.0, 0.0));
    float c = random(i + vec2(0.0, 1.0));
    float d = random(i + vec2(1.0, 1.0));

    vec2 u = f * f * (3.0 - 2.0 * f);

    return mix(a, b, u.x) + (c - a)* u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}

uniform int NUM_OCTAVES = 5;

float fbm ( in vec2 _st) {
	float v = 0.0;
	float a = 0.5;
	vec2 shift = vec2(100.0);
	// Rotate to reduce axial bias
	mat2 rot = mat2(vec2(cos(0.5), sin(0.5)),vec2(-sin(0.5), cos(0.50)));
	for (int i = 0; i < NUM_OCTAVES; ++i) {
		v += a * noise(_st);
		_st = rot * _st * 2.0 + shift;
		a *= 0.5;
	}
	return v;
}

vec2 sphericalFunc(vec2 _uv_shprc1, vec2 _p0s_shprc1, vec2 _rad_shprc1, vec2 _sp1n_shprc1, vec2 _l0c_p0s_shprc1){
	vec2 _temp_p = (_uv_shprc1 - _p0s_shprc1) * 2.0;
	float _temp_rad = length((_temp_p - _l0c_p0s_shprc1) * _rad_shprc1) + 0.0001;
	float _temp_f = (1.0 - sqrt(1.0 - _temp_rad)) / _temp_rad;
	return mod(vec2((_temp_p.x * 0.5 * _temp_f + _sp1n_shprc1.x) + 0.5,
					(_temp_p.y * 0.5 * _temp_f + _sp1n_shprc1.y) + 0.5), 
					vec2(1.0));
}

void fragment() {
	
	vec2 uv = sphericalFunc(UV,vec2(0.5),vec2(1.0),vec2(0.),vec2(0.));
	float alpha = uv.x + uv.y;
	
	vec2 st = uv*6.;
	st.x += TIME * 0.25;
	vec3 color = vec3(0.0);
	
	vec2 q = vec2(0.);
	q.x = fbm( st + 0.00*TIME);
	q.y = fbm( st + vec2(1.0));
	
	vec2 r = vec2(0.);
	r.x = fbm( st + 1.0*q + vec2(1.7,9.2)+ 0.15*TIME);
	r.y = fbm( st + 1.0*q + vec2(8.3,2.8)+ 0.126*TIME);
	
	float f = fbm(st+r);
	
	color = mix(vec3(0.970,0.074,0.028),
				vec3(0.955,0.066,0.048),
				clamp((f*f)*4.0,0.0,1.0));
	
	color = mix(color,
				vec3(0.755,0.710,0.290),
				clamp(length(q),0.0,1.0));
	
	color = mix(color,
				vec3(1.000,0.664,0.281),
				clamp(length(r),0.0,1.0));
	
	COLOR = vec4((f*f*f+.8*f*f+1.*f)*color,alpha);
}