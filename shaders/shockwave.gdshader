shader_type canvas_item;
uniform sampler2D screen : hint_screen_texture;
uniform float distortion = 1.0;
uniform vec2 radius ;
uniform vec2 spin;
uniform vec2 center = vec2(0.5,0.5);
uniform vec2 position = vec2(0,0);
void vertex() {
	// Called for every vertex the material is visible on.
}
vec2 _lensDistortionUV(vec2 _lens_uv, float _lens_factor){
	vec2 _pos_dist_lens = _lens_uv - 0.5;
	float _d1st_d1s_1en5 = length(_pos_dist_lens);
	if (_lens_factor > 0.0) // fisheye / barrel
		_lens_uv = vec2(0.5)+normalize(_pos_dist_lens)*tan(_d1st_d1s_1en5*_lens_factor)*0.70711/tan(0.70711*_lens_factor);
	else if (_lens_factor < 0.0) // antifisheye / pincushion
		_lens_uv = vec2(0.5)+normalize(_pos_dist_lens)*atan(_d1st_d1s_1en5*-_lens_factor*10.0)*0.5/atan(-_lens_factor*0.5*10.0);
	return _lens_uv;
}
vec2 _sphericalUV(vec2 _spherical_uv, vec2 _spherical_position_vect, vec2 _spherical_radius_vect, vec2 _spherical_spin_vect, vec2 _spherical_local_position_vect){
	vec2 _temp_p = (_spherical_uv - _spherical_position_vect) * 2.0;
	float _temp_rad = length((_temp_p - _spherical_local_position_vect) * _spherical_radius_vect) + 0.0001;
	float _temp_f = (1.0 - sqrt(1.0 - _temp_rad)) / _temp_rad;
	return mod(vec2((_temp_p.x * 0.5 * _temp_f + _spherical_spin_vect.x) + 0.5,
					(_temp_p.y * 0.5 * _temp_f + _spherical_spin_vect.y) + 0.5), vec2(1.0));
}
void fragment() {
	if (COLOR.a > 0.0){
		vec2 dis = _lensDistortionUV(SCREEN_UV,distortion);
		vec2 s_dis = _sphericalUV(SCREEN_UV,radius, spin, center, position );
		COLOR = texture(screen, dis * dis);
	}
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
