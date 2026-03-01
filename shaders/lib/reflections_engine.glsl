/* ____    __   ______________
  / ______/ /  /  _/_  __/ __/
 / _//___/ /___/ /  / / / _/
/___/   /____/___/ /_/ /___/

E-LITE shaders 5 - refelctions_engine.glsl #include "/lib/refelctions_engine.glsl"
Reflections calculation. - Cálculo de reflexos. */

vec4 reflection_calc(vec3 reflected, vec3 normal, float roughness) {
    float dither = shifted_eclectic_r_dither(gl_FragCoord.xy);
    if (reflected.z >= 0.0) {
        return vec4(0.0);
    }

    #if defined DISTANT_HORIZONS
        float distFactor = 768.0;
    #else
        float distFactor = 76.0;
    #endif

    vec3 rough_jitter = normal * (dither - 0.5) * roughness * 0.1;
    vec3 refl_dir = reflected + rough_jitter;
    vec3 rayTarget = sub_position3 + refl_dir * distFactor;

    vec3 pos = camera_to_screen(rayTarget);
    vec3 curr_view_pos = rayTarget;

    // Previous texcoord to avoid "out of sync" reflections
    vec3 curr_feet_player_pos = mat3(gbufferModelViewInverse) * curr_view_pos + gbufferModelViewInverse[3].xyz;
    vec3 prev_feet_player_pos = pos.z > 0.56 ? curr_feet_player_pos + cameraPosition - previousCameraPosition : curr_feet_player_pos;
    vec3 prev_view_pos = mat3(gbufferPreviousModelView) * prev_feet_player_pos + gbufferPreviousModelView[3].xyz;
    vec2 final_pos_proj = vec2(gbufferPreviousProjection[0].x, gbufferPreviousProjection[1].y) * prev_view_pos.xy + gbufferPreviousProjection[3].xy;
    vec2 texcoord_past = (final_pos_proj / -prev_view_pos.z) * 0.5 + 0.5;

    float border = min(max(-fourth_pow(abs(2.0 * pos.x - 1.0)) + 1.0, 0.0),
                        max(-fourth_pow(abs(2.0 * pos.y - 1.0)) + 1.0, 0.0));

    float blur_radius = roughness * 0.01;
    vec2 blur_radius_vec = vec2(blur_radius * inv_aspect_ratio, blur_radius);

    float dither_base = dither;
    vec3 col = vec3(0.0);
    float totalWeight = 0.0;
    int samples = 3;

    for(int i = 0; i < samples; i++) {
        float angle = i * 2.0944 + dither * 6.283185;
        vec2 dir = vec2(cos(angle), sin(angle));
        float dist = (float(i) + dither_base) / float(samples);
        
        vec2 sampleOffset = dir * blur_radius_vec * dist;
        col += texture2D(gaux1, texcoord_past + sampleOffset).rgb;
        totalWeight += 1.0;
    }
    col /= totalWeight;

    return vec4(col, border);

}

vec4 solid_shader(vec3 fragpos, vec3 normal, vec4 color, vec3 sky_reflection, float fresnel, float visible_sky, float roughness, float reflex_index) {
    float f_strength = fresnel * reflex_index;
    vec3 reflection_color = mix(color.rgb, sky_reflection, fastpow(visible_sky, 2.0));

    #if REFLECTION == 1
        vec4 ssr = reflection_calc(reflect(fragpos, normal), normal, roughness);
        reflection_color = mix(reflection_color, ssr.rgb, ssr.a);
    #endif

    color.rgb = mix(color.rgb, reflection_color, f_strength);

    return color;
}