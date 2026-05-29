#ifndef E_LITE_INDIRECT_GLSL
#define E_LITE_INDIRECT_GLSL

/*
 * Shadow-space texel indirect lighting for E-LITE.
 * The radiance source is written in the shadow pass, so reflectors can
 * illuminate even when they are outside the camera view.
 */

#ifndef GI_ENABLE
#define GI_ENABLE 1
#endif
#ifndef GI_QUALITY
#define GI_QUALITY 2
#endif
#ifndef GI_INDIRECT_BRIGHTNESS
#define GI_INDIRECT_BRIGHTNESS 2.50
#endif
#ifndef GI_TRACE_DISTANCE
#define GI_TRACE_DISTANCE 18.0
#endif
#ifndef GI_TEXEL_GRID_SIZE
#define GI_TEXEL_GRID_SIZE 16.0
#endif
#ifndef GI_STEP_SIZE
#define GI_STEP_SIZE 0.85
#endif
#ifndef GI_REACH_BOOST
#define GI_REACH_BOOST 2.25
#endif
#ifndef GI_REACH_START_STEPS
#define GI_REACH_START_STEPS 5.0
#endif
#ifndef GI_DISTANCE_FALLOFF
#define GI_DISTANCE_FALLOFF 0.045
#endif
#ifndef GI_ENERGY_GAIN
#define GI_ENERGY_GAIN 1.35
#endif
#ifndef GI_SURFACE_PUSH
#define GI_SURFACE_PUSH 0.08
#endif
#ifndef GI_RAY_COUNT
#define GI_RAY_COUNT 2
#endif
#ifndef GI_MAX_STEPS
#define GI_MAX_STEPS 8
#endif
#ifndef GI_FAST_LOCAL_ENABLE
#define GI_FAST_LOCAL_ENABLE 1
#endif
#ifndef GI_FAST_LOCAL_SAMPLES
#define GI_FAST_LOCAL_SAMPLES 4
#endif
#ifndef GI_SECOND_BOUNCE_ENABLE
#define GI_SECOND_BOUNCE_ENABLE 1
#endif
#ifndef GI_SECOND_BOUNCE_BRIGHTNESS
#define GI_SECOND_BOUNCE_BRIGHTNESS 0.65
#endif
#ifndef GI_SMOOTHING_ENABLE
#define GI_SMOOTHING_ENABLE 1
#endif
#ifndef GI_SMOOTH_STRENGTH
#define GI_SMOOTH_STRENGTH 0.70
#endif
#ifndef GI_CROSS_FACE_ENABLE
#define GI_CROSS_FACE_ENABLE 1
#endif
#ifndef GI_CROSS_FACE_STRENGTH
#define GI_CROSS_FACE_STRENGTH 0.35
#endif
#ifndef GI_LIT_STRENGTH
#define GI_LIT_STRENGTH 0.32
#endif
#ifndef GI_SHADOW_STRENGTH
#define GI_SHADOW_STRENGTH 0.62
#endif
#ifndef GI_MIN_ENERGY
#define GI_MIN_ENERGY 0.003
#endif

const float GI_PI = 3.14159265359;

float giSaturate(float x) { return clamp(x, 0.0, 1.0); }
vec3 giSaturate3(vec3 x) { return clamp(x, vec3(0.0), vec3(1.0)); }
float giMax3(vec3 v) { return max(v.x, max(v.y, v.z)); }

float giHash12(vec2 p) {
    vec3 p3 = fract(vec3(p.xyx) * 0.1031);
    p3 += dot(p3, p3.yzx + 33.33);
    return fract((p3.x + p3.y) * p3.z);
}

float giShadowTexelSize() {
    return 1.0 / float(shadowMapResolution);
}

vec2 giSnapShadowUvToTexel(vec2 uv) {
    float texel = giShadowTexelSize();
    return (floor(uv / texel) + 0.5) * texel;
}

bool giValidShadowUv(vec2 uv) {
    float border = 1.5 * giShadowTexelSize();
    return uv.x > border && uv.x < 1.0 - border && uv.y > border && uv.y < 1.0 - border;
}

vec3 giCardinalNormal(vec3 normal) {
    vec3 a = abs(normal);
    if (a.x > a.y && a.x > a.z) return vec3(sign(normal.x), 0.0, 0.0);
    if (a.y > a.z) return vec3(0.0, sign(normal.y), 0.0);
    return vec3(0.0, 0.0, sign(normal.z));
}

void giFaceFrame(vec3 normal, out vec3 faceNormal, out vec3 tangent, out vec3 bitangent) {
    faceNormal = giCardinalNormal(normal);
    vec3 up = abs(faceNormal.y) > 0.5 ? vec3(0.0, 0.0, 1.0) : vec3(0.0, 1.0, 0.0);
    tangent = normalize(cross(up, faceNormal));
    bitangent = normalize(cross(faceNormal, tangent));
}

vec4 giSampleRadiance(vec2 uv) {
    if (!giValidShadowUv(uv)) return vec4(0.0);
    vec4 r = texture2D(shadowcolor0, giSnapShadowUvToTexel(uv));
    if (giMax3(r.rgb) <= GI_MIN_ENERGY) return vec4(0.0);
    return r;
}

float giOcclusionAlongShadow(vec3 receiverShadowPos, vec2 sampleUv) {
    vec2 uv = giSnapShadowUvToTexel(sampleUv);
    if (!giValidShadowUv(uv)) return 0.0;

    float compareDepth = receiverShadowPos.z - 0.00035;
    float visible = shadow2D(shadowtex1, vec3(uv, compareDepth)).r;
    return mix(0.35, 1.0, visible);
}

vec2 giRayDirection(int rayIndex, vec2 normalUv, float seed) {
    float rays = max(float(GI_RAY_COUNT), 1.0);
    float golden = 2.39996323;
    float angle = (float(rayIndex) + seed) * golden;
    vec2 spiral = vec2(cos(angle), sin(angle));
    return normalize(mix(spiral, normalUv, 0.20));
}

vec3 giTraceShadowTexels(vec3 receiverShadowPos, vec3 normal, vec3 albedo, float shadowMask) {
#if GI_ENABLE <= 0 || GI_QUALITY <= 0
    return vec3(0.0);
#else
    vec3 faceNormal;
    vec3 tangent;
    vec3 bitangent;
    giFaceFrame(normal, faceNormal, tangent, bitangent);

    vec2 receiverUv = giSnapShadowUvToTexel(receiverShadowPos.xy);
    vec2 normalUv = normalize(vec2(faceNormal.x + faceNormal.z * 0.5, faceNormal.y + faceNormal.z * 0.5) + vec2(0.0001));
    float texel = giShadowTexelSize();
    float voxelRadius = max(GI_TEXEL_GRID_SIZE, 1.0);
    float baseStep = texel * max(GI_STEP_SIZE, 0.25) * (64.0 / max(voxelRadius, 1.0));
    float maxRadius = texel * GI_TRACE_DISTANCE;
    float seed = giHash12(floor(receiverUv / texel) + mod(float(frameCounter), 1024.0));

    vec3 accum = vec3(0.0);
    float weightSum = 0.0;

    for (int r = 0; r < GI_RAY_COUNT; ++r) {
        vec2 dir = giRayDirection(r, normalUv, seed);
        for (int s = 1; s <= GI_MAX_STEPS; ++s) {
            float sf = float(s);
            float reach = mix(1.0, GI_REACH_BOOST, smoothstep(GI_REACH_START_STEPS, float(GI_MAX_STEPS), sf));
            float radius = min(maxRadius, baseStep * sf * reach);
            vec2 sampleUv = receiverUv + dir * radius;
            vec4 radiance = giSampleRadiance(sampleUv);

            if (giMax3(radiance.rgb) > GI_MIN_ENERGY) {
                float distFalloff = 1.0 / (1.0 + sf * sf * GI_DISTANCE_FALLOFF);
                float occlusion = giOcclusionAlongShadow(receiverShadowPos, sampleUv);
                float normalTerm = 0.65 + 0.35 * giSaturate(dot(faceNormal, normal));
                float w = distFalloff * occlusion * normalTerm;
                accum += radiance.rgb * w;
                weightSum += w;

#if GI_SECOND_BOUNCE_ENABLE > 0
                accum += radiance.rgb * radiance.rgb * (w * GI_SECOND_BOUNCE_BRIGHTNESS * 0.18);
#endif
                break;
            }
        }
    }

#if GI_FAST_LOCAL_ENABLE > 0
    vec2 localOffset;
    for (int i = 0; i < GI_FAST_LOCAL_SAMPLES; ++i) {
        if (i == 0) localOffset = vec2( 1.0,  0.0);
        else if (i == 1) localOffset = vec2(-1.0,  0.0);
        else if (i == 2) localOffset = vec2( 0.0,  1.0);
        else localOffset = vec2( 0.0, -1.0);
        vec2 localUv = receiverUv + localOffset * texel * 1.5;
        vec4 local = giSampleRadiance(localUv);
        float w = 0.22 * giOcclusionAlongShadow(receiverShadowPos, localUv);
        accum += local.rgb * w;
        weightSum += step(GI_MIN_ENERGY, giMax3(local.rgb)) * w;
    }
#endif

#if GI_CROSS_FACE_ENABLE > 0
    vec2 crossDir = vec2(-normalUv.y, normalUv.x);
    vec4 c0 = giSampleRadiance(receiverUv + crossDir * texel * 2.0);
    vec4 c1 = giSampleRadiance(receiverUv - crossDir * texel * 2.0);
    accum += (c0.rgb + c1.rgb) * GI_CROSS_FACE_STRENGTH * 0.25;
    weightSum += (step(GI_MIN_ENERGY, giMax3(c0.rgb)) + step(GI_MIN_ENERGY, giMax3(c1.rgb))) * GI_CROSS_FACE_STRENGTH * 0.25;
#endif

    if (weightSum <= 0.0) return vec3(0.0);

    vec3 indirect = accum / weightSum;
    float shadowed = 1.0 - giSaturate(shadowMask);
    float strength = mix(GI_LIT_STRENGTH, GI_SHADOW_STRENGTH, shadowed);

#if GI_SMOOTHING_ENABLE > 0
    vec3 neighbor = vec3(0.0);
    float nWeight = 0.0;
    float smoothRadius = texel * 0.75;
    vec4 sx = giSampleRadiance(receiverUv + vec2(smoothRadius, smoothRadius));
    vec4 sy = giSampleRadiance(receiverUv - vec2(smoothRadius, smoothRadius));
    neighbor += sx.rgb + sy.rgb;
    nWeight += step(GI_MIN_ENERGY, giMax3(sx.rgb)) + step(GI_MIN_ENERGY, giMax3(sy.rgb));
    if (nWeight > 0.0) indirect = mix(indirect, neighbor / nWeight, GI_SMOOTH_STRENGTH * 0.20);
#endif

    return giSaturate3(indirect * albedo * GI_INDIRECT_BRIGHTNESS * strength);
#endif
}

vec3 giComputeIndirect(vec3 receiverShadowPos, vec3 normal, vec3 albedo, vec3 shadowColor) {
#if GI_ENABLE <= 0
    return vec3(0.0);
#else
    float shadowMask = giSaturate((shadowColor.r + shadowColor.g + shadowColor.b) * 0.3333333);
    return giTraceShadowTexels(receiverShadowPos, normal, albedo, shadowMask);
#endif
}

#endif
