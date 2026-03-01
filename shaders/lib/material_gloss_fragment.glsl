#if defined THE_END
    vec3 material_gloss(vec3 reflected_vector, vec2 lmcoord_alt, float gloss_power, vec3 flat_normal, vec3 lightColor) {
        vec3 astro_pos = (gbufferModelView * vec4(0.0, 0.89442719, 0.4472136, 0.0)).xyz;

        float dot_r_a = dot(normalize(reflected_vector), normalize(astro_pos));
        if (dot_r_a < 0.5) return vec3(0.0); 

        float astro_vector = dot_r_a * step(0.0001, dot(astro_pos, flat_normal));
        
        return vec3(clamp(mix(0.0, 1.0, fastpow(clamp(astro_vector * 2.0 - 1.0, 0.0, 1.0), 16.0)), 0.0, 1.0)) * 0.015;
    }  
#else
    vec3 material_gloss(vec3 reflected_vector, vec2 lmcoord_alt, float gloss_power, vec3 flat_normal, vec3 lightColor) {
        vec3 astro_pos = mix(-sunPosition, sunPosition, light_mix);

        float dot_r_a = dot(normalize(reflected_vector), normalize(astro_pos));
        if (dot_r_a < 0.5) return vec3(0.0);

        float astro_vector = dot_r_a * step(0.0001, dot(astro_pos, flat_normal));
        float base_gloss_intensity = pow(astro_vector * 2.0 - 1.0, gloss_power);

        return clamp(
            base_gloss_intensity * saturate(lightColor, 0.25) * day_blend_float(1.5, 0.5, 2.5) * lmcoord_alt.y * (1.1 - rainStrength) * abs(mix(1.333, -1.0, light_mix)),
            0.0,
            1.0
        );
    }
#endif

// SIMPLIFIED.