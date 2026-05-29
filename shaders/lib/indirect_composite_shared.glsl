#ifndef E_LITE_INDIRECT_COMPOSITE_SHARED_GLSL
#define E_LITE_INDIRECT_COMPOSITE_SHARED_GLSL

#include "/lib/indirect_common.glsl"
#define SAMPLE_SHADOW_RUNTIME
#define E_LITE_INDIRECT_EXTERNAL_SHADOW_SAMPLERS
#include "/lib/indirect_shadow_shared.glsl"

uniform sampler2D colortex0;
uniform sampler2D colortex1;
uniform sampler2D colortex2;
uniform sampler2D colortex3;
uniform sampler2D depthtex0;

float sampleSceneDepth(vec2 uv) {
    return texture2D(depthtex0, uv).r;
}

vec4 sampleSceneAlbedo(vec2 uv) {
    return texture2D(colortex0, uv);
}

vec4 sampleSceneLightmapMaterial(vec2 uv) {
    return texture2D(colortex1, uv);
}

vec3 sampleSceneNormal(vec2 uv) {
    return decodeNormalFromColor(texture2D(colortex2, uv).rgb);
}

vec3 getSimpleGradientSky(vec2 uv) {
    vec3 top = vec3(0.17, 0.30, 0.56);
    vec3 horizon = vec3(0.52, 0.68, 0.90);
    float h = saturate(uv.y);
    float rainDim = mix(1.0, 0.75, rainStrength);
    return mix(horizon, top, pow(h, 1.35)) * rainDim;
}

vec3 getCardinalFaceNormal(vec3 normal) {
    return decodeCardinalNormalFromScalar(encodeCardinalNormalToScalar(normal));
}

#ifndef GI_FACE_FILL_STRENGTH
#define GI_FACE_FILL_STRENGTH 0.00
#endif
#ifndef GI_LIT_STRENGTH
#define GI_LIT_STRENGTH 0.20
#endif
#ifndef GI_SHADOW_STRENGTH
#define GI_SHADOW_STRENGTH 0.55
#endif
#ifndef SHADOW_HARD_LIT_THRESHOLD
#define SHADOW_HARD_LIT_THRESHOLD 0.75
#endif

float getHardShadowLitMask(float shadowMask) {
    return step(SHADOW_HARD_LIT_THRESHOLD, saturate(shadowMask));
}

#ifndef GI_RAY_COUNT
#define GI_RAY_COUNT 5
#endif
#ifndef GI_MAX_STEPS
#define GI_MAX_STEPS 20
#endif
#ifndef VOXEL_SUN_TRACE_MAX_STEPS
#define VOXEL_SUN_TRACE_MAX_STEPS 8
#endif
#ifndef GI_ATTEMPT_COUNT
#define GI_ATTEMPT_COUNT 1
#endif
#ifndef VOXEL_GI_MIN_STEP
#define VOXEL_GI_MIN_STEP 0.85
#endif
#ifndef GI_REACH_BOOST
#define GI_REACH_BOOST 2.50
#endif
#ifndef GI_REACH_START_STEPS
#define GI_REACH_START_STEPS 6.0
#endif
#ifndef GI_DISTANCE_FALLOFF
#define GI_DISTANCE_FALLOFF 0.045
#endif
#ifndef VOXEL_SUN_TRACE_STEP
#define VOXEL_SUN_TRACE_STEP 1.00
#endif
#ifndef VOXEL_GI_VALID_ALPHA_MIN
#define VOXEL_GI_VALID_ALPHA_MIN 0.01
#endif
#ifndef VOXEL_GI_SELF_SKIP
#define VOXEL_GI_SELF_SKIP 0.30
#endif
#ifndef VOXEL_GI_MAX_TRANSFER
#define VOXEL_GI_MAX_TRANSFER 1.75
#endif
#ifndef VOXEL_GI_ATTEMPT_OFFSET
#define VOXEL_GI_ATTEMPT_OFFSET 0.18
#endif
#ifndef VOXEL_GI_EARLY_ACCEPT_RAYS
#define VOXEL_GI_EARLY_ACCEPT_RAYS 2.0
#endif
#ifndef VOXEL_GI_FAST_LIT_THRESHOLD
#define VOXEL_GI_FAST_LIT_THRESHOLD 0.92
#endif
#ifndef VOXEL_GI_FAST_NDOTL_THRESHOLD
#define VOXEL_GI_FAST_NDOTL_THRESHOLD 0.45
#endif
#ifndef VOXEL_GI_FAST_LOCAL_STRENGTH
#define VOXEL_GI_FAST_LOCAL_STRENGTH 0.12
#endif
#ifndef VOXEL_GI_SECOND_BOUNCE_DIRECTION_BLEND
#define VOXEL_GI_SECOND_BOUNCE_DIRECTION_BLEND 0.35
#endif
#ifndef VOXEL_GI_PROBE_RADIUS
#define VOXEL_GI_PROBE_RADIUS 0.32
#endif
#ifndef VOXEL_GI_PROBE_CROSS_RADIUS
#define VOXEL_GI_PROBE_CROSS_RADIUS 0.20
#endif
#ifndef VOXEL_GI_BLOCKER_ENABLE
#define VOXEL_GI_BLOCKER_ENABLE 1
#endif
#ifndef VOXEL_GI_BLOCKER_DEPTH_TOLERANCE
#define VOXEL_GI_BLOCKER_DEPTH_TOLERANCE 0.0028
#endif
#ifndef VOXEL_GI_BLOCKER_BACKSTEP
#define VOXEL_GI_BLOCKER_BACKSTEP 0.35
#endif
#ifndef GI_SMOOTHING_ENABLE
#define GI_SMOOTHING_ENABLE 1
#endif
#ifndef GI_FAST_SMOOTHING
#define GI_FAST_SMOOTHING 1
#endif
#ifndef GI_FAST_LIT_ONLY
#define GI_FAST_LIT_ONLY 1
#endif
#ifndef GI_CROSS_FACE_SHADOW_ONLY
#define GI_CROSS_FACE_SHADOW_ONLY 1
#endif
#ifndef GI_FAST_LOCAL_SAMPLES
#define GI_FAST_LOCAL_SAMPLES 2
#endif
#ifndef GI_SUN_TRACE_ENABLE
#define GI_SUN_TRACE_ENABLE 0
#endif
#ifndef GI_LIT_RAY_COUNT
#define GI_LIT_RAY_COUNT 1
#endif
#ifndef GI_SMOOTH_STRENGTH
#define GI_SMOOTH_STRENGTH 0.45
#endif
#ifndef GI_SMOOTH_RADIUS
#define GI_SMOOTH_RADIUS 1.0
#endif
#ifndef GI_SMOOTH_SAMPLES
#define GI_SMOOTH_SAMPLES 4
#endif
#ifndef GI_CROSS_FACE_ENABLE
#define GI_CROSS_FACE_ENABLE 1
#endif
#ifndef GI_CROSS_FACE_STRENGTH
#define GI_CROSS_FACE_STRENGTH 0.55
#endif
#ifndef GI_CROSS_FACE_RAYS
#define GI_CROSS_FACE_RAYS 4
#endif
#ifndef GI_CROSS_FACE_NORMAL_WEIGHT
#define GI_CROSS_FACE_NORMAL_WEIGHT 0.46
#endif
#ifndef GI_CROSS_FACE_SIDE_WEIGHT
#define GI_CROSS_FACE_SIDE_WEIGHT 0.89
#endif
#ifndef GI_CROSS_FACE_MAX_STEPS
#define GI_CROSS_FACE_MAX_STEPS 8
#endif
#ifndef GI_CROSS_FACE_TRACE_DISTANCE
#define GI_CROSS_FACE_TRACE_DISTANCE 10.0
#endif
#ifndef GI_TEMPORAL_ACCUMULATION_ENABLE
#define GI_TEMPORAL_ACCUMULATION_ENABLE 1
#endif
#ifndef GI_TEMPORAL_HISTORY_WEIGHT
#define GI_TEMPORAL_HISTORY_WEIGHT 0.72
#endif
#ifndef GI_TEMPORAL_COLOR_TOLERANCE
#define GI_TEMPORAL_COLOR_TOLERANCE 0.55
#endif
#ifndef GI_ALWAYS_FLICKER_ENABLE
#define GI_ALWAYS_FLICKER_ENABLE 1
#endif
#ifndef GI_FLICKER_STRENGTH
#define GI_FLICKER_STRENGTH 1.00
#endif

int wrapIndex120(int value, int modulus) {
    if (modulus <= 0) {
        return 0;
    }
    return value - (value / modulus) * modulus;
}

vec3 sampleFastLocalIndirect(vec3 worldPos, vec3 normal);
vec3 sampleFastLocalIndirectFromAnchor(vec3 centerAnchor, vec3 normal);
vec3 traceVoxelFirstBounceIndirectFromAnchor(vec3 stableAnchor, vec3 normal, float shadowMask, float dotSun);
vec3 traceVoxelFirstBounceIndirect(vec3 worldPos, vec3 normal, float shadowMask, float dotSun);
vec3 traceVoxelCrossFaceIndirectFromAnchor(vec3 stableAnchor, vec3 normal);
vec3 sampleVoxelGridSmoothedIndirect(vec3 worldPos, vec3 normal, float shadowMask, float dotSun);

float getGiFramePhase() {
#if GI_ALWAYS_FLICKER_ENABLE <= 0
    return 0.0;
#else
    return float(frameCounter) * max(float(GI_FLICKER_STRENGTH), 0.0);
#endif
}

vec3 getTemporalHistoryClamped(vec3 historyColor, vec3 currentColor) {
    float currentLum = luminance(currentColor);
    float tolerance = max(float(GI_TEMPORAL_COLOR_TOLERANCE), 0.0) * (0.25 + currentLum * 0.75);
    vec3 lo = max(vec3(0.0), currentColor - vec3(tolerance));
    vec3 hi = currentColor + vec3(tolerance);
    return clamp(historyColor, lo, hi);
}

vec3 accumulateTemporalGi(vec2 uv, vec3 worldPos, vec3 currentColor) {
#if GI_TEMPORAL_ACCUMULATION_ENABLE <= 0
    return currentColor;
#else
    vec2 historyUv = worldToPreviousScreen(worldPos);
    if (!isUvInsideScreen(historyUv)) {
        return currentColor;
    }

    vec4 historySample = texture2D(colortex3, historyUv);
    if (historySample.a <= 0.001 || maxComponent(historySample.rgb) <= 0.0) {
        return currentColor;
    }

    vec3 historyColor = getTemporalHistoryClamped(sanitizeColor(historySample.rgb), currentColor);
    float colorDelta = abs(luminance(currentColor) - luminance(historyColor));
    float historyValidity = 1.0 - smoothstep(0.18, 1.25, colorDelta);

    float cameraDelta = length(cameraPosition - previousCameraPosition);
    float cameraResponse = 1.0 - smoothstep(0.015, 0.18, cameraDelta);

    float historyWeight = saturate(float(GI_TEMPORAL_HISTORY_WEIGHT)) * historyValidity;
    historyWeight *= mix(0.35, 1.0, cameraResponse);
    return sanitizeColor(mix(currentColor, historyColor, historyWeight));
#endif
}

float getGiSmoothRadius() {
    return max(float(GI_SMOOTH_RADIUS), 0.0);
}

vec2 getGiInterVoxelWeight(vec2 voxelFrac) {
    vec2 f = clamp(voxelFrac, vec2(0.0), vec2(1.0));
    // Curva suave entre centros de voxels: perto do centro a GI fica estavel,
    // e a mistura cresce principalmente ao atravessar a regiao entre voxels.
    return f * f * (vec2(3.0) - vec2(2.0) * f);
}

void getGiInterVoxelOffsets(vec3 worldPos, vec3 faceNormal, out vec2 lowerOffset, out vec2 upperOffset, out vec2 voxelWeight) {
    vec2 local = getFaceLocalUV(worldPos, faceNormal);

    // Amostragem contínua: a posição no bloco só influencia o deslocamento,
    // sem prender a GI a células fixas.
    vec2 centered = (local - vec2(0.5)) * 2.0;
    vec2 offset = centered * GI_SMOOTH_RADIUS;

    lowerOffset = -offset;
    upperOffset = offset;
    voxelWeight = getGiInterVoxelWeight(local);
}
vec3 getSecondBounceDirection(vec3 sourceNormal, vec3 incomingRayDir, vec3 patternSeed, int rayIndex);
vec3 traceVoxelSecondBounceIndirect(vec3 firstHitPos, vec3 firstHitNormal, vec3 firstBounceEnergy, vec3 originalSourceBlock, vec3 incomingRayDir, float traveledSoFar, int rayIndex, int attemptIndex);

vec3 getShadowPenetratingIndirect(vec3 worldPos, vec3 normal, vec3 albedo, float shadowMask, float dotSun) {
#if GI_ENABLE <= 0 || GI_QUALITY <= 0
    return vec3(0.0);
#else
    float shadowed = 1.0 - saturate(shadowMask);
    float voxelStrength = mix(GI_LIT_STRENGTH, GI_SHADOW_STRENGTH, shadowed);
    vec3 voxelIndirect = sampleVoxelGridSmoothedIndirect(worldPos, normal, shadowMask, dotSun);

#if GI_FAST_LOCAL_ENABLE > 0
    // A aproximação local fica apenas como reforço nas áreas bem iluminadas.
    // Na sombra, a GI completa precisa continuar valendo para não perder o bounce.
    if (shadowMask >= VOXEL_GI_FAST_LIT_THRESHOLD && dotSun >= VOXEL_GI_FAST_NDOTL_THRESHOLD) {
        voxelIndirect = max(voxelIndirect, sampleFastLocalIndirect(worldPos, normal));
    }
#endif

    return voxelIndirect * albedo * voxelStrength;
#endif
}

bool hasShadowVoxelInfo(vec4 info) {
    return info.a > VOXEL_GI_VALID_ALPHA_MIN && maxComponent(info.rgb) > GI_MIN_ENERGY;
}

float getVoxelDistanceAttenuation(float dist) {
    // Falloff um pouco mais longo para que a GI que viaja mais longe ainda
    // contribua de forma visivel, sem criar um piso ambiente artificial.
    float falloff = max(float(GI_DISTANCE_FALLOFF), 0.001);
    return 1.0 / (1.0 + dist * dist * falloff);
}

float getVoxelGiRayTravel(int stepIndex, float firstStepOffset, float rayStep) {
    // Mantem os primeiros passos densos perto do receptor e estica apenas a
    // cauda do raio. Assim a GI alcanca mais blocos sem aumentar GI_RAY_COUNT
    // nem GI_MAX_STEPS.
    float stepCoord = float(stepIndex) + firstStepOffset;
    float denseSteps = max(float(GI_REACH_START_STEPS), 0.0);
    float nearSteps = min(stepCoord, denseSteps);
    float farSteps = max(stepCoord - denseSteps, 0.0);
    float reachBoost = max(float(GI_REACH_BOOST), 1.0);
    return (nearSteps + farSteps * reachBoost) * rayStep;
}

float getVoxelDirectEnergy(vec3 energy) {
    return maxComponent(energy);
}

float traceVoxelToSun(vec3 voxelPos, vec3 voxelNormal) {
#if GI_SUN_TRACE_ENABLE <= 0 || VOXEL_SUN_TRACE_MAX_STEPS <= 0
    // Caminho rápido: o shadow pass já injeta energia apenas nas superfícies vistas pela luz.
    // Evita um segundo raymarch para cada acerto de GI.
    return 1.0;
#else
    vec3 lightDir = getWorldShadowLightDirection();
    vec3 sourceBlock = getFaceBlockIndexFromPushedAnchor(voxelPos, voxelNormal);
    vec3 startPos = voxelPos + safeNormalize(voxelNormal) * (GI_SURFACE_PUSH + GI_NORMAL_BIAS) + lightDir * VOXEL_GI_SELF_SKIP;

    for (int i = 0; i < VOXEL_SUN_TRACE_MAX_STEPS; ++i) {
        float t = float(i) * VOXEL_SUN_TRACE_STEP;
        if (t > SHADOW_DISTANCE) {
            break;
        }

        vec3 probePos = startPos + lightDir * t;
        vec3 stc = projectWorldToShadowTexcoord(probePos);
        if (!isValidShadowTexcoord(stc)) {
            return 1.0;
        }

        vec4 probeInfo = sampleShadowMaterialInfoStable(probePos);
        if (hasShadowVoxelInfo(probeInfo)) {
            vec3 probeBlock = getWorldBlockIndex(probePos);
            vec3 delta = abs(probeBlock - sourceBlock);
            if (max(delta.x, max(delta.y, delta.z)) > 0.5) {
                return 0.0;
            }
        }
    }

    return 1.0;
#endif
}

bool isBlockOutsideReference(vec3 blockIndex, vec3 referenceBlock) {
    vec3 delta = abs(blockIndex - referenceBlock);
    return max(delta.x, max(delta.y, delta.z)) > 0.5;
}

bool isOutsideReferenceBlock(vec3 worldPos, vec3 referenceBlock) {
    vec3 delta = abs(getWorldBlockIndex(worldPos) - referenceBlock);
    return max(delta.x, max(delta.y, delta.z)) > 0.5;
}

bool sampleShadowSurfaceBlockerStable(vec3 worldPos, out vec4 info) {
#if VOXEL_GI_BLOCKER_ENABLE <= 0
    info = vec4(0.0);
    return false;
#else
    vec3 stc = projectWorldToShadowTexcoord(worldPos);
    if (!isValidShadowTexcoord(stc)) {
        info = vec4(0.0);
        return false;
    }

    if (sampleShadowCompare(stc) <= 0.01) {
        info = vec4(0.0);
        return false;
    }

    float texelSize = getShadowMapTexelSize();
    vec2 stableUv = (floor(stc.xy / texelSize) + 0.5) * texelSize;
    info = texture2D(shadowcolor0, stableUv);
    return true;
#endif
}

bool isProbeOnPackedFacePlane(vec3 hitPos, vec3 hitNormal) {
#if GI_FACE_SAMPLE_GUARD <= 0
    return true;
#else
    vec3 faceNormal = getCardinalFaceNormal(hitNormal);
    vec3 hitBlock = getFaceBlockIndexFromPushedAnchor(hitPos, faceNormal);
    vec3 local = worldRelativeToAbsolute(hitPos) - hitBlock;
    float planeCoord = 0.0;
    float targetCoord = 0.0;
    vec2 sideCoords = vec2(0.0);

    if (abs(faceNormal.x) > 0.5) {
        planeCoord = local.x;
        targetCoord = faceNormal.x > 0.0 ? 1.0 : 0.0;
        sideCoords = local.yz;
    } else if (abs(faceNormal.y) > 0.5) {
        planeCoord = local.y;
        targetCoord = faceNormal.y > 0.0 ? 1.0 : 0.0;
        sideCoords = local.xz;
    } else {
        planeCoord = local.z;
        targetCoord = faceNormal.z > 0.0 ? 1.0 : 0.0;
        sideCoords = local.xy;
    }

    float planeTolerance = max(GI_FACE_SAMPLE_PLANE_TOLERANCE, GI_VOXEL_WORLD_SIZE * 1.5);
    float sideMargin = GI_FACE_SAMPLE_LATERAL_MARGIN;
    bool nearCorrectPlane = abs(planeCoord - targetCoord) <= planeTolerance;
    bool insideFace = sideCoords.x >= -sideMargin && sideCoords.x <= 1.0 + sideMargin &&
                      sideCoords.y >= -sideMargin && sideCoords.y <= 1.0 + sideMargin;
    return nearCorrectPlane && insideFace;
#endif
}

vec3 getGiHitBlockIndex(vec3 hitPos, vec3 hitNormal) {
    return getFaceBlockIndexFromPushedAnchor(hitPos, hitNormal);
}

bool isValidVoxelGiHit(vec4 info, vec3 hitPos, vec3 excludeBlockA, vec3 excludeBlockB, bool useExcludeBlockB) {
    if (!hasShadowVoxelInfo(info)) {
        return false;
    }

    vec3 hitNormal = decodeCardinalNormalFromScalar(info.a);
    if (!isProbeOnPackedFacePlane(hitPos, hitNormal)) {
        return false;
    }
    vec3 hitBlock = getGiHitBlockIndex(hitPos, hitNormal);
    if (!isBlockOutsideReference(hitBlock, excludeBlockA)) {
        return false;
    }
    if (useExcludeBlockB && !isBlockOutsideReference(hitBlock, excludeBlockB)) {
        return false;
    }
    return true;
}

vec4 sampleVoxelGiProbeCandidate(vec3 candidatePos, vec3 excludeBlockA, vec3 excludeBlockB, bool useExcludeBlockB, out vec3 hitPos, out bool rayBlocked) {
    hitPos = candidatePos;
    rayBlocked = false;

    vec4 info;
    bool surfaceHit = sampleShadowSurfaceBlockerStable(candidatePos, info);
    if (!surfaceHit) {
        return vec4(0.0);
    }

    // Encontrou uma face solida no caminho. Se ela nao puder contribuir com GI
    // por estar sem energia, por ser o bloco excluido, ou por falhar na trava
    // de face, o raio ainda deve parar aqui em vez de atravessar o bloco.
    rayBlocked = true;
    if (isValidVoxelGiHit(info, candidatePos, excludeBlockA, excludeBlockB, useExcludeBlockB)) {
        return info;
    }
    return vec4(0.0);
}

vec4 sampleVoxelGiProbeExpanded(vec3 probePos, vec3 receiverNormal, vec3 rayDir, float rayPhase, vec3 excludeBlockA, vec3 excludeBlockB, bool useExcludeBlockB, out vec3 hitPos, out bool rayBlocked) {
    hitPos = probePos;
    rayBlocked = false;

    bool candidateBlocked = false;
    vec4 info = sampleVoxelGiProbeCandidate(probePos, excludeBlockA, excludeBlockB, useExcludeBlockB, hitPos, candidateBlocked);
    if (hasShadowVoxelInfo(info)) {
        rayBlocked = candidateBlocked;
        return info;
    }
    if (candidateBlocked) {
        rayBlocked = true;
        return vec4(0.0);
    }

#if VOXEL_GI_BLOCKER_ENABLE > 0
    // Ajuda a pegar a face de entrada quando o passo do raio pula um pouco
    // para dentro do bloco entre duas amostras.
    info = sampleVoxelGiProbeCandidate(probePos - safeNormalize(rayDir) * VOXEL_GI_BLOCKER_BACKSTEP, excludeBlockA, excludeBlockB, useExcludeBlockB, hitPos, candidateBlocked);
    if (hasShadowVoxelInfo(info)) {
        rayBlocked = candidateBlocked;
        return info;
    }
    if (candidateBlocked) {
        rayBlocked = true;
        return vec4(0.0);
    }
#endif

#if GI_PROBE_EXPAND <= 0
    return vec4(0.0);
#else
    vec3 faceNormal;
    vec3 tangent;
    vec3 bitangent;
    getCardinalFaceFrame(receiverNormal, faceNormal, tangent, bitangent);

    float angle = rayPhase * TAU;
    vec3 sweepDir = safeNormalize(tangent * cos(angle) + bitangent * sin(angle));
    vec3 crossDir = safeNormalize(tangent * -sin(angle) + bitangent * cos(angle));

    info = sampleVoxelGiProbeCandidate(probePos + sweepDir * VOXEL_GI_PROBE_RADIUS, excludeBlockA, excludeBlockB, useExcludeBlockB, hitPos, candidateBlocked);
    if (hasShadowVoxelInfo(info)) {
        rayBlocked = candidateBlocked;
        return info;
    }
    if (candidateBlocked) {
        rayBlocked = true;
        return vec4(0.0);
    }

    info = sampleVoxelGiProbeCandidate(probePos - sweepDir * VOXEL_GI_PROBE_RADIUS, excludeBlockA, excludeBlockB, useExcludeBlockB, hitPos, candidateBlocked);
    if (hasShadowVoxelInfo(info)) {
        rayBlocked = candidateBlocked;
        return info;
    }
    if (candidateBlocked) {
        rayBlocked = true;
        return vec4(0.0);
    }

    info = sampleVoxelGiProbeCandidate(probePos + crossDir * VOXEL_GI_PROBE_CROSS_RADIUS, excludeBlockA, excludeBlockB, useExcludeBlockB, hitPos, candidateBlocked);
    if (hasShadowVoxelInfo(info)) {
        rayBlocked = candidateBlocked;
        return info;
    }
    if (candidateBlocked) {
        rayBlocked = true;
        return vec4(0.0);
    }

    info = sampleVoxelGiProbeCandidate(probePos - crossDir * VOXEL_GI_PROBE_CROSS_RADIUS, excludeBlockA, excludeBlockB, useExcludeBlockB, hitPos, candidateBlocked);
    if (hasShadowVoxelInfo(info)) {
        rayBlocked = candidateBlocked;
        return info;
    }
    if (candidateBlocked) {
        rayBlocked = true;
        return vec4(0.0);
    }

    return vec4(0.0);
#endif
}

vec3 getVoxelIndirectAttemptAnchorFromStableAnchor(vec3 stableAnchor, vec3 normal, int attemptIndex) {
    vec3 faceNormal;
    vec3 tangent;
    vec3 bitangent;
    getCardinalFaceFrame(normal, faceNormal, tangent, bitangent);

    // stableAnchor ja e o centro do voxel receptor. Nao re-snapar aqui e importante:
    // a suavizacao passa centros de voxels vizinhos explicitamente e um novo snap
    // poderia prender a amostra de volta ao voxel do pixel atual.
    vec3 anchor = stableAnchor;
    vec3 receiverBlock = getFaceBlockIndexFromPushedAnchor(stableAnchor, faceNormal);
    vec2 anchorHash = hash23(receiverBlock + faceNormal * 3.17 + anchor * 0.11);
    float tangentSign = anchorHash.x < 0.5 ? -1.0 : 1.0;
    float bitangentSign = anchorHash.y < 0.5 ? -1.0 : 1.0;

    if (attemptIndex == 1) {
        anchor += (tangent * tangentSign + bitangent * bitangentSign) * VOXEL_GI_ATTEMPT_OFFSET;
    } else if (attemptIndex == 2) {
        anchor += (tangent * -tangentSign + bitangent * -bitangentSign) * VOXEL_GI_ATTEMPT_OFFSET;
    }

    return anchor;
}

vec3 getVoxelIndirectAttemptAnchor(vec3 worldPos, vec3 normal, int attemptIndex) {
    vec3 faceNormal = getCardinalFaceNormal(normal);
    vec3 stableAnchor = getStableVoxelSampleAnchor(worldPos, faceNormal);
    return getVoxelIndirectAttemptAnchorFromStableAnchor(stableAnchor, faceNormal, attemptIndex);
}

vec3 getSecondBounceDirection(vec3 sourceNormal, vec3 incomingRayDir, vec3 patternSeed, int rayIndex) {
    int patternIndex = wrapIndex120(rayIndex * 5 + 2, GI_RAY_COUNT);
    vec3 hemisphereDir = getDeterministicHemisphereDirection(patternIndex, sourceNormal, patternSeed);
    vec3 reflectedDir = reflect(incomingRayDir, sourceNormal);
    if (dot(reflectedDir, sourceNormal) <= EPSILON) {
        reflectedDir = sourceNormal;
    }

    vec3 bounceDir = safeNormalize(mix(hemisphereDir, safeNormalize(reflectedDir), VOXEL_GI_SECOND_BOUNCE_DIRECTION_BLEND));
    if (dot(bounceDir, sourceNormal) <= EPSILON) {
        bounceDir = hemisphereDir;
    }
    return bounceDir;
}

vec3 traceVoxelSecondBounceIndirect(vec3 firstHitPos, vec3 firstHitNormal, vec3 firstBounceEnergy, vec3 originalSourceBlock, vec3 incomingRayDir, float traveledSoFar, int rayIndex, int attemptIndex) {
#if GI_SECOND_BOUNCE_ENABLE <= 0
    return vec3(0.0);
#else
    float remainingDistance = GI_TRACE_DISTANCE - traveledSoFar;
    if (remainingDistance <= EPSILON) {
        return vec3(0.0);
    }

    vec3 firstBlock = getWorldBlockIndex(firstHitPos);
    vec3 patternSeed = originalSourceBlock + firstBlock * 0.73 + firstHitNormal * 9.17 + vec3(float(rayIndex), float(attemptIndex) * 3.0, 19.0);
    vec3 bounceDir = getSecondBounceDirection(firstHitNormal, incomingRayDir, patternSeed, rayIndex);
    float sourceLaunch = max(0.0, dot(firstHitNormal, bounceDir));
    if (sourceLaunch <= EPSILON) {
        return vec3(0.0);
    }

    float rayStep = max(GI_STEP_SIZE, VOXEL_GI_MIN_STEP);
    float rayPhase = hash13(patternSeed + vec3(41.0, 17.0, 13.0));
    float firstStepOffset = 0.60 + rayPhase * 0.70;
    vec3 startPos = getStableVoxelSampleAnchor(firstHitPos, firstHitNormal) + bounceDir * VOXEL_GI_SELF_SKIP;

    for (int stepIndex = 0; stepIndex < GI_MAX_STEPS; ++stepIndex) {
        float bounceTravel = getVoxelGiRayTravel(stepIndex, firstStepOffset, rayStep);
        float totalTravel = traveledSoFar + bounceTravel;
        if (bounceTravel > remainingDistance || totalTravel > GI_TRACE_DISTANCE) {
            break;
        }

        vec3 probePos = startPos + bounceDir * bounceTravel;
        vec3 probeHitPos;
        bool rayBlocked = false;
        vec4 probeInfo = sampleVoxelGiProbeExpanded(probePos, firstHitNormal, bounceDir, rayPhase, firstBlock, originalSourceBlock, true, probeHitPos, rayBlocked);
        if (!hasShadowVoxelInfo(probeInfo)) {
            if (rayBlocked) {
                break;
            }
            continue;
        }

        vec3 reflectorNormal = decodeCardinalNormalFromScalar(probeInfo.a);
        float differentOrientation = 1.0 - step(0.985, dot(reflectorNormal, firstHitNormal));
        if (differentOrientation <= 0.0) {
            break;
        }

        float reflectorFacing = max(0.0, dot(reflectorNormal, -bounceDir));
        if (reflectorFacing <= EPSILON) {
            break;
        }

        float distAtten = getVoxelDistanceAttenuation(totalTravel);
        float transfer = min(sourceLaunch * reflectorFacing * distAtten * differentOrientation, VOXEL_GI_MAX_TRANSFER);
        if (transfer > EPSILON) {
            return firstBounceEnergy * transfer * GI_SECOND_BOUNCE_BRIGHTNESS;
        }
        break;
    }

    return vec3(0.0);
#endif
}

vec3 traceVoxelIndirectAttempt(vec3 startPos, vec3 sourceBlock, vec3 normal, int attemptIndex, int rayBudget, int stepBudget, out float successfulRays) {
    vec3 accum = vec3(0.0);
    float rayStep = max(GI_STEP_SIZE, VOXEL_GI_MIN_STEP);
    successfulRays = 0.0;

    vec3 faceNormal = getCardinalFaceNormal(normal);
    vec2 faceTexelCoord = getFaceTexelCoord(startPos, faceNormal);
    float framePhase = getGiFramePhase();
    vec3 rayPatternSeed = sourceBlock + faceNormal * 7.13 +
                          vec3(faceTexelCoord.x * 17.0 + faceTexelCoord.y * 31.0 + framePhase * 0.37,
                               faceTexelCoord.y * 19.0 + faceTexelCoord.x * 11.0 + float(attemptIndex) * 5.0 + framePhase * 1.11,
                               11.0 + framePhase * 0.73);

    for (int rayIndex = 0; rayIndex < GI_RAY_COUNT; ++rayIndex) {
        if (rayIndex >= rayBudget) {
            break;
        }

        int frameShift = int(mod(getGiFramePhase(), max(float(GI_RAY_COUNT), 1.0)));
        int patternIndex = wrapIndex120(rayIndex + attemptIndex * 3 + frameShift, GI_RAY_COUNT);
        vec3 rayDir = getDeterministicHemisphereDirection(patternIndex, faceNormal, rayPatternSeed);
        float receiverFacing = max(0.0, dot(faceNormal, rayDir));
        if (receiverFacing <= EPSILON) {
            continue;
        }

        float rayPhase = hash13(rayPatternSeed + vec3(float(patternIndex) * 1.91, float(rayIndex) * 0.73, 23.0));
        float firstStepOffset = 0.60 + rayPhase * 0.70;

        for (int stepIndex = 0; stepIndex < GI_MAX_STEPS; ++stepIndex) {
            if (stepIndex >= stepBudget) {
                break;
            }

            float travel = getVoxelGiRayTravel(stepIndex, firstStepOffset, rayStep);
            if (travel > GI_TRACE_DISTANCE) {
                break;
            }

            vec3 probePos = startPos + rayDir * travel;
            vec3 probeHitPos;
            bool rayBlocked = false;
            vec4 probeInfo = sampleVoxelGiProbeExpanded(probePos, faceNormal, rayDir, rayPhase, sourceBlock, sourceBlock, false, probeHitPos, rayBlocked);
            if (!hasShadowVoxelInfo(probeInfo)) {
                if (rayBlocked) {
                    break;
                }
                continue;
            }

            vec3 reflectorNormal = decodeCardinalNormalFromScalar(probeInfo.a);
            float differentOrientation = 1.0 - step(0.985, dot(reflectorNormal, faceNormal));
            if (differentOrientation <= 0.0) {
                break;
            }

            float reflectorFacing = max(0.0, dot(reflectorNormal, -rayDir));
            if (reflectorFacing <= EPSILON) {
                break;
            }

            vec3 reflectorEnergy = probeInfo.rgb;
            float directEnergy = getVoxelDirectEnergy(reflectorEnergy);
            if (directEnergy <= GI_MIN_ENERGY) {
                break;
            }

            float sunVisibility = traceVoxelToSun(probeHitPos, reflectorNormal);
            float distAtten = getVoxelDistanceAttenuation(travel);
            float transfer = min(receiverFacing * reflectorFacing * distAtten * sunVisibility, VOXEL_GI_MAX_TRANSFER);
            if (transfer > EPSILON) {
                vec3 firstBounceEnergy = reflectorEnergy * transfer;
                accum += firstBounceEnergy;
                accum += traceVoxelSecondBounceIndirect(probeHitPos, reflectorNormal, firstBounceEnergy, sourceBlock, rayDir, travel, rayIndex, attemptIndex);
                successfulRays += 1.0;
            }
            break;
        }

        if (successfulRays >= VOXEL_GI_EARLY_ACCEPT_RAYS) {
            break;
        }
    }

    return accum;
}

vec3 sampleVoxelGridAnchorOffsetIndirect(vec3 centerAnchor, vec3 faceNormal, vec3 tangent, vec3 bitangent, vec2 gridOffset, vec3 centerIndirect, float shadowMask, float dotSun) {
    float smoothRadius = getGiSmoothRadius();
    vec2 scaledOffset = gridOffset * smoothRadius;
    if (smoothRadius <= EPSILON || (abs(gridOffset.x) < 0.5 && abs(gridOffset.y) < 0.5)) {
        return centerIndirect;
    }

    // Desloca um ou mais voxels da grade configurável da face, com raio configuravel.
    // No modo rápido, a suavização usa sondas locais baratas em vez de retraçar
    // GI completa nos vizinhos. Isso preserva a transição entre voxels sem
    // multiplicar GI_RAY_COUNT * GI_MAX_STEPS por cada amostra de suavização.
    vec3 offsetAnchor = centerAnchor + (tangent * scaledOffset.x + bitangent * scaledOffset.y) / GI_TEXEL_GRID_SIZE;
#if GI_FAST_SMOOTHING > 0
    vec3 localApprox = sampleFastLocalIndirectFromAnchor(offsetAnchor, faceNormal);
    float hasLocal = step(EPSILON, maxComponent(localApprox));
    vec3 conservativeLocal = max(centerIndirect * 0.72, localApprox);
    return mix(centerIndirect, conservativeLocal, hasLocal * 0.50);
#else
    return traceVoxelFirstBounceIndirectFromAnchor(offsetAnchor, faceNormal, shadowMask, dotSun) +
           traceVoxelCrossFaceIndirectFromAnchor(offsetAnchor, faceNormal);
#endif
}

vec3 sampleVoxelGridSmoothedIndirect(vec3 worldPos, vec3 normal, float shadowMask, float dotSun) {
    vec3 faceNormal;
    vec3 tangent;
    vec3 bitangent;
    getCardinalFaceFrame(normal, faceNormal, tangent, bitangent);

    vec3 centerAnchor = getStableVoxelSampleAnchor(worldPos, faceNormal);
    vec3 baseIndirect = traceVoxelFirstBounceIndirectFromAnchor(centerAnchor, faceNormal, shadowMask, dotSun);
#if GI_CROSS_FACE_ENABLE > 0 && GI_CROSS_FACE_RAYS > 0
    vec3 crossFaceIndirect = traceVoxelCrossFaceIndirectFromAnchor(centerAnchor, faceNormal);
#if GI_CROSS_FACE_SHADOW_ONLY > 0
    // Em faces bem iluminadas, a GI cruzada ainda precisa contribuir um pouco
    // para preencher a metade superior/lateral da face sem reabrir o custo completo.
    bool litFace = (shadowMask >= VOXEL_GI_FAST_LIT_THRESHOLD && dotSun >= VOXEL_GI_FAST_NDOTL_THRESHOLD);
    baseIndirect += crossFaceIndirect * (litFace ? 0.75 : 1.0);
#else
    baseIndirect += crossFaceIndirect;
#endif
#endif

#if GI_SMOOTHING_ENABLE <= 0 || GI_SMOOTH_SAMPLES <= 0
    return baseIndirect;
#else
    float smoothStrength = saturate(GI_SMOOTH_STRENGTH);
    float smoothRadius = getGiSmoothRadius();
    if (smoothStrength <= EPSILON || smoothRadius <= EPSILON) {
        return baseIndirect;
    }

    // Interpolacao real entre voxels da face receptora. A posicao do pixel so
    // gera pesos; cada amostra abaixo parte do centro estavel de um voxel vizinho.
    vec2 lowerOffset;
    vec2 upperOffset;
    vec2 voxelWeight;
    getGiInterVoxelOffsets(worldPos, faceNormal, lowerOffset, upperOffset, voxelWeight);

#if GI_SMOOTH_SAMPLES >= 4
    vec3 gi00 = sampleVoxelGridAnchorOffsetIndirect(centerAnchor, faceNormal, tangent, bitangent, vec2(lowerOffset.x, lowerOffset.y), baseIndirect, shadowMask, dotSun);
    vec3 gi10 = sampleVoxelGridAnchorOffsetIndirect(centerAnchor, faceNormal, tangent, bitangent, vec2(upperOffset.x, lowerOffset.y), baseIndirect, shadowMask, dotSun);
    vec3 gi01 = sampleVoxelGridAnchorOffsetIndirect(centerAnchor, faceNormal, tangent, bitangent, vec2(lowerOffset.x, upperOffset.y), baseIndirect, shadowMask, dotSun);
    vec3 gi11 = sampleVoxelGridAnchorOffsetIndirect(centerAnchor, faceNormal, tangent, bitangent, vec2(upperOffset.x, upperOffset.y), baseIndirect, shadowMask, dotSun);

    vec3 interpX0 = mix(gi00, gi10, voxelWeight.x);
    vec3 interpX1 = mix(gi01, gi11, voxelWeight.x);
    vec3 interVoxelIndirect = mix(interpX0, interpX1, voxelWeight.y);
#else
    bool useTangentAxis = abs(voxelWeight.x - 0.5) >= abs(voxelWeight.y - 0.5);
    float axisFrac = useTangentAxis ? voxelWeight.x : voxelWeight.y;
    vec2 offsetA = useTangentAxis ? vec2(lowerOffset.x, 0.0) : vec2(0.0, lowerOffset.y);
    vec2 offsetB = useTangentAxis ? vec2(upperOffset.x, 0.0) : vec2(0.0, upperOffset.y);

    vec3 giA = sampleVoxelGridAnchorOffsetIndirect(centerAnchor, faceNormal, tangent, bitangent, offsetA, baseIndirect, shadowMask, dotSun);
    vec3 giB = sampleVoxelGridAnchorOffsetIndirect(centerAnchor, faceNormal, tangent, bitangent, offsetB, baseIndirect, shadowMask, dotSun);
    vec3 interVoxelIndirect = mix(giA, giB, axisFrac);
#endif

    return mix(baseIndirect, interVoxelIndirect, smoothStrength);
#endif
}

vec3 sampleFastLocalIndirectFromAnchor(vec3 centerAnchor, vec3 normal) {
#if GI_FAST_LOCAL_ENABLE <= 0
    return vec3(0.0);
#else
    vec3 faceNormal;
    vec3 tangent;
    vec3 bitangent;
    getCardinalFaceFrame(normal, faceNormal, tangent, bitangent);

    vec3 receiverBlock = getFaceBlockIndexFromPushedAnchor(centerAnchor, faceNormal);
    vec3 probePos0 = centerAnchor + tangent * 0.18;
    vec3 probePos1 = centerAnchor - tangent * 0.18;
    vec4 probe0 = sampleShadowMaterialInfoStable(probePos0);
    vec4 probe1 = sampleShadowMaterialInfoStable(probePos1);

    vec3 accum = vec3(0.0);
    float weight = 0.0;

    if (isValidVoxelGiHit(probe0, probePos0, receiverBlock, receiverBlock, false)) {
        vec3 n0 = decodeCardinalNormalFromScalar(probe0.a);
        accum += probe0.rgb * mix(1.0, 0.55, step(0.985, dot(n0, faceNormal)));
        weight += 1.0;
    }
    if (isValidVoxelGiHit(probe1, probePos1, receiverBlock, receiverBlock, false)) {
        vec3 n1 = decodeCardinalNormalFromScalar(probe1.a);
        accum += probe1.rgb * mix(1.0, 0.55, step(0.985, dot(n1, faceNormal)));
        weight += 1.0;
    }
#if GI_FAST_LOCAL_SAMPLES >= 4
    vec3 probePos2 = centerAnchor + bitangent * 0.18;
    vec3 probePos3 = centerAnchor - bitangent * 0.18;
    vec4 probe2 = sampleShadowMaterialInfoStable(probePos2);
    vec4 probe3 = sampleShadowMaterialInfoStable(probePos3);

    if (isValidVoxelGiHit(probe2, probePos2, receiverBlock, receiverBlock, false)) {
        vec3 n2 = decodeCardinalNormalFromScalar(probe2.a);
        accum += probe2.rgb * mix(1.0, 0.55, step(0.985, dot(n2, faceNormal)));
        weight += 1.0;
    }
    if (isValidVoxelGiHit(probe3, probePos3, receiverBlock, receiverBlock, false)) {
        vec3 n3 = decodeCardinalNormalFromScalar(probe3.a);
        accum += probe3.rgb * mix(1.0, 0.55, step(0.985, dot(n3, faceNormal)));
        weight += 1.0;
    }
#endif

    if (weight <= 0.0) {
        return vec3(0.0);
    }

    return (accum / weight) * (GI_INDIRECT_BRIGHTNESS * VOXEL_GI_FAST_LOCAL_STRENGTH);
#endif
}

vec3 sampleFastLocalAnchorOffsetIndirect(vec3 centerAnchor, vec3 faceNormal, vec3 tangent, vec3 bitangent, vec2 gridOffset, vec3 centerIndirect) {
#if GI_FAST_LOCAL_ENABLE <= 0
    return vec3(0.0);
#else
    float smoothRadius = getGiSmoothRadius();
    vec2 scaledOffset = gridOffset * smoothRadius;
    if (smoothRadius <= EPSILON || (abs(gridOffset.x) < 0.5 && abs(gridOffset.y) < 0.5)) {
        return centerIndirect;
    }

    vec3 offsetAnchor = centerAnchor + (tangent * scaledOffset.x + bitangent * scaledOffset.y) / GI_TEXEL_GRID_SIZE;
    return sampleFastLocalIndirectFromAnchor(offsetAnchor, faceNormal);
#endif
}

vec3 sampleFastLocalIndirect(vec3 worldPos, vec3 normal) {
#if GI_FAST_LOCAL_ENABLE <= 0
    return vec3(0.0);
#else
    vec3 faceNormal;
    vec3 tangent;
    vec3 bitangent;
    getCardinalFaceFrame(normal, faceNormal, tangent, bitangent);

    vec3 centerAnchor = getStableVoxelSampleAnchor(worldPos, faceNormal);
    vec3 baseIndirect = sampleFastLocalIndirectFromAnchor(centerAnchor, faceNormal);

#if GI_SMOOTHING_ENABLE <= 0 || GI_SMOOTH_SAMPLES <= 0
    return baseIndirect;
#else
    float smoothStrength = saturate(GI_SMOOTH_STRENGTH);
    float smoothRadius = getGiSmoothRadius();
    if (smoothStrength <= EPSILON || smoothRadius <= EPSILON) {
        return baseIndirect;
    }

    vec2 lowerOffset;
    vec2 upperOffset;
    vec2 voxelWeight;
    getGiInterVoxelOffsets(worldPos, faceNormal, lowerOffset, upperOffset, voxelWeight);

#if GI_SMOOTH_SAMPLES >= 4
    vec3 gi00 = sampleFastLocalAnchorOffsetIndirect(centerAnchor, faceNormal, tangent, bitangent, vec2(lowerOffset.x, lowerOffset.y), baseIndirect);
    vec3 gi10 = sampleFastLocalAnchorOffsetIndirect(centerAnchor, faceNormal, tangent, bitangent, vec2(upperOffset.x, lowerOffset.y), baseIndirect);
    vec3 gi01 = sampleFastLocalAnchorOffsetIndirect(centerAnchor, faceNormal, tangent, bitangent, vec2(lowerOffset.x, upperOffset.y), baseIndirect);
    vec3 gi11 = sampleFastLocalAnchorOffsetIndirect(centerAnchor, faceNormal, tangent, bitangent, vec2(upperOffset.x, upperOffset.y), baseIndirect);

    vec3 interpX0 = mix(gi00, gi10, voxelWeight.x);
    vec3 interpX1 = mix(gi01, gi11, voxelWeight.x);
    vec3 interVoxelIndirect = mix(interpX0, interpX1, voxelWeight.y);
#else
    bool useTangentAxis = abs(voxelWeight.x - 0.5) >= abs(voxelWeight.y - 0.5);
    float axisFrac = useTangentAxis ? voxelWeight.x : voxelWeight.y;
    vec2 offsetA = useTangentAxis ? vec2(lowerOffset.x, 0.0) : vec2(0.0, lowerOffset.y);
    vec2 offsetB = useTangentAxis ? vec2(upperOffset.x, 0.0) : vec2(0.0, upperOffset.y);

    vec3 giA = sampleFastLocalAnchorOffsetIndirect(centerAnchor, faceNormal, tangent, bitangent, offsetA, baseIndirect);
    vec3 giB = sampleFastLocalAnchorOffsetIndirect(centerAnchor, faceNormal, tangent, bitangent, offsetB, baseIndirect);
    vec3 interVoxelIndirect = mix(giA, giB, axisFrac);
#endif

    return mix(baseIndirect, interVoxelIndirect, smoothStrength);
#endif
#endif
}

vec3 getCrossFaceSideDirection(int rayIndex, vec3 tangent, vec3 bitangent) {
    if (rayIndex == 0) return safeNormalize(tangent + bitangent);
    if (rayIndex == 1) return safeNormalize(-tangent + bitangent);
    if (rayIndex == 2) return safeNormalize(tangent - bitangent);
    return safeNormalize(-tangent - bitangent);
}

vec3 traceVoxelCrossFaceIndirectFromAnchor(vec3 stableAnchor, vec3 normal) {
#if GI_ENABLE <= 0 || GI_CROSS_FACE_ENABLE <= 0 || GI_CROSS_FACE_RAYS <= 0
    return vec3(0.0);
#else
    vec3 faceNormal;
    vec3 tangent;
    vec3 bitangent;
    getCardinalFaceFrame(normal, faceNormal, tangent, bitangent);

    vec3 receiverBlock = getFaceBlockIndexFromPushedAnchor(stableAnchor, faceNormal);
    vec3 seedBase = receiverBlock + faceNormal * 13.31 + stableAnchor * 0.19 + vec3(getGiFramePhase() * 0.41, getGiFramePhase() * 0.19, getGiFramePhase() * 0.67);
    vec3 accum = vec3(0.0);
    float successfulRays = 0.0;

    float rayStep = max(GI_STEP_SIZE * 0.75, 0.38);
    for (int rayIndex = 0; rayIndex < 4; ++rayIndex) {
        if (rayIndex >= GI_CROSS_FACE_RAYS) {
            break;
        }

        vec3 sideDir = getCrossFaceSideDirection(rayIndex, tangent, bitangent);
        float sideJitter = hash13(seedBase + sideDir * 5.73 + vec3(float(rayIndex), 4.0, 9.0)) * 2.0 - 1.0;
        vec3 rayDir = safeNormalize(faceNormal * GI_CROSS_FACE_NORMAL_WEIGHT +
                                    sideDir * GI_CROSS_FACE_SIDE_WEIGHT +
                                    (tangent - bitangent) * (sideJitter * 0.045));
        float receiverFacing = max(0.0, dot(faceNormal, rayDir));
        if (receiverFacing <= EPSILON) {
            continue;
        }

        float rayPhase = hash13(seedBase + vec3(float(rayIndex) * 2.17, 21.0, 3.0));
        float firstStepOffset = 0.35 + rayPhase * 0.45;
        vec3 startPos = stableAnchor + rayDir * VOXEL_GI_SELF_SKIP;

        for (int stepIndex = 0; stepIndex < GI_MAX_STEPS; ++stepIndex) {
            if (stepIndex >= GI_CROSS_FACE_MAX_STEPS) {
                break;
            }

            float travel = getVoxelGiRayTravel(stepIndex, firstStepOffset, rayStep);
            if (travel > min(GI_TRACE_DISTANCE, GI_CROSS_FACE_TRACE_DISTANCE)) {
                break;
            }

            vec3 probePos = startPos + rayDir * travel;
            vec3 probeHitPos;
            bool rayBlocked = false;
            vec4 probeInfo = sampleVoxelGiProbeExpanded(probePos, faceNormal, rayDir, rayPhase,
                                                         receiverBlock, receiverBlock, false, probeHitPos, rayBlocked);
            if (!hasShadowVoxelInfo(probeInfo)) {
                if (rayBlocked) {
                    break;
                }
                continue;
            }

            vec3 reflectorNormal = decodeCardinalNormalFromScalar(probeInfo.a);
            // Nao duplicar a coleta principal da mesma orientacao. Aqui o objetivo
            // e fazer paredes, teto, chao e laterais trocarem energia entre si.
            float differentOrientation = 1.0 - step(0.985, dot(reflectorNormal, faceNormal));
            if (differentOrientation <= 0.0) {
                break;
            }

            float reflectorFacing = max(0.0, dot(reflectorNormal, -rayDir));
            if (reflectorFacing <= EPSILON) {
                break;
            }

            vec3 reflectorEnergy = probeInfo.rgb;
            if (getVoxelDirectEnergy(reflectorEnergy) <= GI_MIN_ENERGY) {
                break;
            }

            float sunVisibility = traceVoxelToSun(probeHitPos, reflectorNormal);
            float distAtten = getVoxelDistanceAttenuation(travel);
            float transfer = min(receiverFacing * reflectorFacing * distAtten *
                                 sunVisibility * differentOrientation, VOXEL_GI_MAX_TRANSFER);
            if (transfer > EPSILON) {
                accum += reflectorEnergy * transfer;
                successfulRays += 1.0;
            }
            break;
        }
    }

    if (successfulRays <= 0.0) {
        return vec3(0.0);
    }

    return (accum / float(GI_CROSS_FACE_RAYS)) * GI_INDIRECT_BRIGHTNESS * GI_CROSS_FACE_STRENGTH;
#endif
}

vec3 traceVoxelFirstBounceIndirectFromAnchor(vec3 stableAnchor, vec3 normal, float shadowMask, float dotSun) {
    vec3 n = getCardinalFaceNormal(normal);
    vec3 bestAccum = vec3(0.0);
    float bestEnergy = 0.0;
    float bestSuccessfulRays = 0.0;

    // Usa a mesma quantidade de raios em áreas iluminadas e não iluminadas.
    int rayBudget = GI_RAY_COUNT;
    int stepBudget = GI_MAX_STEPS;
#if GI_QUALITY <= 1
    int attemptBudget = 1;
#elif GI_QUALITY == 2
    int attemptBudget = (shadowMask < VOXEL_GI_FAST_LIT_THRESHOLD || dotSun < VOXEL_GI_FAST_NDOTL_THRESHOLD) ? ((GI_ATTEMPT_COUNT < 2) ? GI_ATTEMPT_COUNT : 2) : 1;
#else
    int attemptBudget = (shadowMask < VOXEL_GI_FAST_LIT_THRESHOLD || dotSun < VOXEL_GI_FAST_NDOTL_THRESHOLD) ? GI_ATTEMPT_COUNT : 1;
#endif

    for (int attemptIndex = 0; attemptIndex < GI_ATTEMPT_COUNT; ++attemptIndex) {
        if (attemptIndex >= attemptBudget) {
            break;
        }

        vec3 startPos = getVoxelIndirectAttemptAnchorFromStableAnchor(stableAnchor, n, attemptIndex);
        vec3 sourceBlock = getFaceBlockIndexFromPushedAnchor(stableAnchor, n);
        float successfulRays = 0.0;
        vec3 attemptAccum = traceVoxelIndirectAttempt(startPos, sourceBlock, n, attemptIndex, rayBudget, stepBudget, successfulRays);

        if (successfulRays <= 0.0) {
            continue;
        }

        float attemptEnergy = luminance(attemptAccum);
        if (attemptEnergy > bestEnergy) {
            bestEnergy = attemptEnergy;
            bestAccum = attemptAccum;
            bestSuccessfulRays = successfulRays;
        }

        if (successfulRays >= VOXEL_GI_EARLY_ACCEPT_RAYS) {
            break;
        }
    }

    if (bestSuccessfulRays <= 0.0) {
        return vec3(0.0);
    }

    return (bestAccum / float(rayBudget)) * GI_INDIRECT_BRIGHTNESS;
}

vec3 traceVoxelFirstBounceIndirect(vec3 worldPos, vec3 normal, float shadowMask, float dotSun) {
    vec3 n = getCardinalFaceNormal(normal);
    vec3 stableAnchor = getStableVoxelSampleAnchor(worldPos, n);
    return traceVoxelFirstBounceIndirectFromAnchor(stableAnchor, n, shadowMask, dotSun);
}

vec3 getDirectSunColor() {
    vec3 daySun = vec3(1.30, 1.20, 1.00);
    vec3 nightMoon = vec3(0.42, 0.48, 0.62);
    vec3 sunDir = safeNormalize(getWorldVectorFromView(sunPosition));
    float useMoon = step(0.0, -sunDir.y);
    vec3 directColor = mix(daySun, nightMoon, useMoon);
    return directColor * mix(1.0, 0.65, rainStrength);
}

vec3 getBlockEmission(vec3 albedo, vec2 lightmap) {
    float blockLight = saturate(lightmap.x);
    float curve = blockLight * blockLight;
    curve *= curve;
    return albedo * curve * 1.35;
}

vec3 composeLitSurfaceWithTemporalIndirect(vec2 uv, vec3 worldPos, vec3 normal, vec3 albedo, vec2 lightmap, out vec3 temporalIndirect) {
    vec3 n = safeNormalize(normal);
    vec3 faceNormal = getCardinalFaceNormal(n);
    vec3 lightDir = getWorldShadowLightDirection();

    float shadowMask = sampleShadowMask(worldPos, faceNormal);
    float dotSun = clamp(dot(n, lightDir), 0.0, 1.0);

    // Sem iluminação do céu: nenhuma contribuição do lightmap Y/skylight entra aqui.
    vec3 direct = getDirectSunColor() * (dotSun * shadowMask * DIRECT_LIGHT_STRENGTH) * albedo;
    vec3 indirect = getShadowPenetratingIndirect(worldPos, faceNormal, albedo, shadowMask, dotSun);
    vec3 emission = getBlockEmission(albedo, lightmap);

    // A acumulação temporal atua somente sobre a iluminação indireta.
    // Iluminação direta, emissão e céu continuam sempre do frame atual.
    temporalIndirect = accumulateTemporalGi(uv, worldPos, indirect);

    vec3 finalColor = direct + temporalIndirect + emission;
    finalColor *= WORLD_BRIGHTNESS;
    return sanitizeColor(finalColor);
}

vec3 composeLitSurface(vec2 uv, vec3 worldPos, vec3 normal, vec3 albedo, vec2 lightmap) {
    vec3 temporalIndirect = vec3(0.0);
    return composeLitSurfaceWithTemporalIndirect(uv, worldPos, normal, albedo, lightmap, temporalIndirect);
}
#endif
