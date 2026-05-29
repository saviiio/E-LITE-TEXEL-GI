#ifndef E_LITE_INDIRECT_COMMON_GLSL
#define E_LITE_INDIRECT_COMMON_GLSL

#ifndef E_LITE_UNIFORM_GBUFFER_MODEL_VIEW_INVERSE
uniform mat4 gbufferModelViewInverse;
#endif
#ifndef E_LITE_UNIFORM_GBUFFER_PROJECTION_INVERSE
uniform mat4 gbufferProjectionInverse;
#endif
#ifndef E_LITE_UNIFORM_GBUFFER_MODEL_VIEW
uniform mat4 gbufferModelView;
#endif
#ifndef E_LITE_UNIFORM_GBUFFER_PROJECTION
uniform mat4 gbufferProjection;
#endif
#ifndef E_LITE_UNIFORM_GBUFFER_PREVIOUS_MODEL_VIEW
uniform mat4 gbufferPreviousModelView;
#endif
#ifndef E_LITE_UNIFORM_GBUFFER_PREVIOUS_PROJECTION
uniform mat4 gbufferPreviousProjection;
#endif
#ifndef E_LITE_UNIFORM_SHADOW_MODEL_VIEW
uniform mat4 shadowModelView;
#endif
#ifndef E_LITE_UNIFORM_SHADOW_PROJECTION
uniform mat4 shadowProjection;
#endif
#ifndef E_LITE_UNIFORM_SHADOW_MODEL_VIEW_INVERSE
uniform mat4 shadowModelViewInverse;
#endif
#ifndef E_LITE_UNIFORM_SHADOW_PROJECTION_INVERSE
uniform mat4 shadowProjectionInverse;
#endif

#ifndef E_LITE_UNIFORM_CAMERA_POSITION
uniform vec3 cameraPosition;
#endif
#ifndef E_LITE_UNIFORM_PREVIOUS_CAMERA_POSITION
uniform vec3 previousCameraPosition;
#endif
#ifndef E_LITE_UNIFORM_SUN_POSITION
uniform vec3 sunPosition;
#endif
#ifndef E_LITE_UNIFORM_MOON_POSITION
uniform vec3 moonPosition;
#endif
#ifndef E_LITE_UNIFORM_SHADOW_LIGHT_POSITION
uniform vec3 shadowLightPosition;
#endif
#ifndef E_LITE_UNIFORM_UP_POSITION
uniform vec3 upPosition;
#endif

#ifndef E_LITE_UNIFORM_FRAME_COUNTER
uniform int frameCounter;
#endif
#ifndef E_LITE_UNIFORM_FRAME_TIME_COUNTER
uniform float frameTimeCounter;
#endif
#ifndef E_LITE_UNIFORM_RAIN_STRENGTH
uniform float rainStrength;
#endif
#ifndef E_LITE_UNIFORM_WETNESS
uniform float wetness;
#endif
#ifndef E_LITE_UNIFORM_ASPECT_RATIO
uniform float aspectRatio;
#endif
#ifndef E_LITE_UNIFORM_VIEW_WIDTH
uniform float viewWidth;
#endif
#ifndef E_LITE_UNIFORM_VIEW_HEIGHT
uniform float viewHeight;
#endif

const float voxelDistance = 80.0; // [32.0 48.0 64.0 80.0 96.0 112.0 128.0 160.0] Distância de geração dos voxels ao redor da câmera

// Buffer persistente para acumulacao temporal. Nao limpar permite ler a historia do frame anterior.
/*
const int colortex0Format = RGBA16F;
const int colortex3Format = RGBA16F;
*/

const float PI = 3.14159265359;
const float TAU = 6.28318530718;
const float EPSILON = 1.0e-5;

#ifndef WORLD_BRIGHTNESS
#define WORLD_BRIGHTNESS 1.00
#endif
#ifndef DIRECT_LIGHT_STRENGTH
#define DIRECT_LIGHT_STRENGTH 1.25
#endif
#ifndef GI_INDIRECT_BRIGHTNESS
#define GI_INDIRECT_BRIGHTNESS 5.50
#endif
#ifndef GI_SECOND_BOUNCE_BRIGHTNESS
#define GI_SECOND_BOUNCE_BRIGHTNESS 1.60
#endif
#ifndef GI_TRACE_DISTANCE
#define GI_TRACE_DISTANCE 24.0
#endif
#ifndef GI_STEP_SIZE
#define GI_STEP_SIZE 0.5
#endif
#ifndef GI_SURFACE_PUSH
#define GI_SURFACE_PUSH 0.08
#endif
#ifndef GI_ENERGY_GAIN
#define GI_ENERGY_GAIN 2.20
#endif
const float GI_MAX_ENERGY = 3.0;
const float GI_MIN_ENERGY = 0.0;
const float GI_NORMAL_BIAS = 0.06;
const float GI_LUMA_PRESERVATION = 0.82;
const float GI_OCCLUSION_STRENGTH = 0.75;
#ifndef GI_TEXEL_GRID_SIZE
#define GI_TEXEL_GRID_SIZE 8.0
#endif
// GI_TEXEL_GRID_SIZE = 8.0 divide cada face de bloco em 8x8 voxels.
// Com o shadowmap padrão, isso reduz a face projetada de ~2x2 px para ~1x1 px.
const float GI_VOXEL_WORLD_SIZE = 1.0 / GI_TEXEL_GRID_SIZE;
const float GI_VOXEL_FACE_DEPTH = GI_VOXEL_WORLD_SIZE * 0.5;
// Recuo pequeno para identificar o bloco dono de uma face na borda.
const float GI_FACE_BLOCK_EPSILON = 0.002;
#ifndef GI_FACE_SAMPLE_GUARD
#define GI_FACE_SAMPLE_GUARD 1
#endif
#ifndef GI_SHADOWCOLOR_DEPTH_TOLERANCE
#define GI_SHADOWCOLOR_DEPTH_TOLERANCE 0.0014
#endif
const float GI_FACE_SAMPLE_LATERAL_MARGIN = 0.20;
const float GI_FACE_SAMPLE_PLANE_TOLERANCE = 0.22;

const float SHADOW_MAP_RESOLUTION = float(shadowMapResolution);
const float SHADOW_DISTANCE = shadowDistance;
#ifndef SHADOW_MAP_BIAS
#define SHADOW_MAP_BIAS 0.0015
#endif
#ifndef SHADOW_FILTER_MODE
#define SHADOW_FILTER_MODE 1
#endif
#ifndef SHADOW_PCF_RADIUS
#define SHADOW_PCF_RADIUS 0.75
#endif
#ifndef SHADOW_BIAS_FIXED
#define SHADOW_BIAS_FIXED SHADOW_MAP_BIAS
#endif
#ifndef SHADOW_RECEIVER_BIAS
#define SHADOW_RECEIVER_BIAS 0.0000
#endif
#ifndef SHADOW_NORMAL_OFFSET
#define SHADOW_NORMAL_OFFSET 0.025
#endif
const float SHADOW_PASS_NORMAL_OFFSET = 0.000;
const float SHADOW_CONSERVATIVE_EXPANSION = 0.010;
const float SHADOW_FACE_LINEAR_SCALE = 1.0049876;
const float SHADOW_Z_COMPRESSION = 0.18;
const float SHADOW_RADIAL_DISTORTION = 0.10;

float saturate(float x) {
    return clamp(x, 0.0, 1.0);
}

vec2 saturate(vec2 x) {
    return clamp(x, vec2(0.0), vec2(1.0));
}

vec3 saturate(vec3 x) {
    return clamp(x, vec3(0.0), vec3(1.0));
}

vec4 saturate(vec4 x) {
    return clamp(x, vec4(0.0), vec4(1.0));
}

float maxComponent(vec3 v) {
    return max(v.x, max(v.y, v.z));
}

float luminance(vec3 c) {
    return dot(c, vec3(0.2126, 0.7152, 0.0722));
}

vec3 safeNormalize(vec3 v) {
    float lenSq = dot(v, v);
    if (lenSq < EPSILON) return vec3(0.0, 1.0, 0.0);
    return v * inversesqrt(lenSq);
}

mat3 mat3FromMat4(mat4 m) {
    return mat3(m[0].xyz, m[1].xyz, m[2].xyz);
}

vec3 sanitizeColor(vec3 c) {
    return clamp(max(c, vec3(0.0)), vec3(0.0), vec3(65000.0));
}

vec4 stripVanillaShadingKeepTint(vec4 vertexColor) {
    float l = max(luminance(vertexColor.rgb), 0.0001);
    vec3 tint = vertexColor.rgb / l;
    return vec4(clamp(tint, 0.0, 4.0), vertexColor.a);
}

float getColorChroma(vec3 color) {
    float hi = maxComponent(color);
    float lo = min(color.x, min(color.y, color.z));
    return hi - lo;
}

vec3 applyFaceAwareVertexTint(vec3 textureColor, vec3 vertexTint) {
    // Texturas quase cinzas, como grass/leaves tintadas por bioma, precisam
    // manter o tint do vertice. Texturas ja coloridas, como dirt/bottom de
    // grass block, nao devem herdar o verde da face de cima.
    float chroma = getColorChroma(textureColor);
    float tintKeep = 1.0 - smoothstep(0.08, 0.22, chroma);
    vec3 faceTint = mix(vec3(1.0), vertexTint, tintKeep);
    return textureColor * faceTint;
}

vec3 encodeNormalToColor(vec3 n) {
    return n * 0.5 + 0.5;
}

vec3 decodeNormalFromColor(vec3 c) {
    return safeNormalize(c * 2.0 - 1.0);
}

float hash11(float p) {
    p = fract(p * 0.1031);
    p *= p + 33.33;
    p *= p + p;
    return fract(p);
}

#ifndef E_LITE_HASH13_DEFINED
#define E_LITE_HASH13_DEFINED
float hash13(vec3 p3) {
    p3 = fract(p3 * 0.1031);
    p3 += dot(p3, p3.yzx + 33.33);
    return fract((p3.x + p3.y) * p3.z);
}
#endif

vec2 hash23(vec3 p3) {
    float n = hash13(p3);
    return fract(vec2(n, n + hash11(n + 0.37)) * vec2(113.1, 271.9));
}

vec3 getWorldVectorFromView(vec3 viewVector) {
    return mat3FromMat4(gbufferModelViewInverse) * viewVector;
}

vec3 worldToView(vec3 worldPos) {
    return (gbufferModelView * vec4(worldPos, 1.0)).xyz;
}

vec3 viewToWorld(vec3 viewPos) {
    return (gbufferModelViewInverse * vec4(viewPos, 1.0)).xyz;
}

vec3 screenToView(vec2 uv, float depth) {
    vec4 clipPos = vec4(uv * 2.0 - 1.0, depth * 2.0 - 1.0, 1.0);
    vec4 viewPos = gbufferProjectionInverse * clipPos;
    return viewPos.xyz / max(viewPos.w, EPSILON);
}

vec3 screenToWorld(vec2 uv, float depth) {
    vec3 viewPos = screenToView(uv, depth);
    return viewToWorld(viewPos);
}

vec2 worldToScreen(vec3 worldPos) {
    vec4 clipPos = gbufferProjection * vec4(worldToView(worldPos), 1.0);
    vec2 ndc = clipPos.xy / max(clipPos.w, EPSILON);
    return ndc * 0.5 + 0.5;
}

vec3 getPrimaryLightDirection() {
    vec3 sunDir = safeNormalize(getWorldVectorFromView(sunPosition));
    vec3 moonDir = safeNormalize(getWorldVectorFromView(moonPosition));
    float useMoon = step(0.0, -sunDir.y);
    return safeNormalize(mix(sunDir, moonDir, useMoon));
}

vec3 getCameraPositionBestFract() {
    return fract(cameraPosition);
}

vec3 getCameraPositionIntFloor() {
    return floor(cameraPosition);
}

vec3 getPreviousCameraPositionIntFloor() {
    return floor(previousCameraPosition);
}

vec3 getCameraIntegerStepOffset() {
    return getCameraPositionIntFloor() - getPreviousCameraPositionIntFloor();
}

vec3 worldRelativeToAbsolute(vec3 worldPos) {
    return worldPos + cameraPosition;
}

vec3 worldAbsoluteToRelative(vec3 worldPos) {
    return worldPos - cameraPosition;
}

vec3 worldToStableVoxelSpace(vec3 worldPos) {
    return worldRelativeToAbsolute(worldPos);
}

vec3 stableVoxelSpaceToWorld(vec3 stablePos) {
    return worldAbsoluteToRelative(stablePos);
}

vec3 getBlockAnchoredVoxelIndex(vec3 worldPos) {
    return floor(worldRelativeToAbsolute(worldPos));
}

vec3 getWorldBlockIndex(vec3 worldPos) {
    return floor(worldRelativeToAbsolute(worldPos));
}

vec3 getFaceBlockIndexFromSurface(vec3 worldPos, vec3 faceNormal) {
    return getWorldBlockIndex(worldPos - safeNormalize(faceNormal) * GI_FACE_BLOCK_EPSILON);
}

vec3 getFaceBlockIndexFromPushedAnchor(vec3 pushedAnchor, vec3 faceNormal) {
    float reenterDistance = GI_SURFACE_PUSH + GI_NORMAL_BIAS + GI_FACE_BLOCK_EPSILON;
    return getWorldBlockIndex(pushedAnchor - safeNormalize(faceNormal) * reenterDistance);
}

vec3 snapWorldToVoxelGrid(vec3 worldPos, float voxelSize) {
    vec3 absolutePos = worldRelativeToAbsolute(worldPos);
    absolutePos = (floor(absolutePos / voxelSize) + 0.5) * voxelSize;
    return worldAbsoluteToRelative(absolutePos);
}

float getShadowStableInterval() {
    return max(shadowIntervalSize, EPSILON);
}

vec3 getShadowStableCameraOrigin() {
    float intervalSize = getShadowStableInterval();
    return floor(cameraPosition / intervalSize) * intervalSize;
}

vec3 getShadowStableCameraOffset() {
    // Mesmo principio da GI voxel: volta para coordenada absoluta do mundo e
    // reancora em uma origem inteira/estavel. Assim a projecao da sombra nao
    // acompanha a fracao da posicao da camera a cada passo pequeno do jogador.
    return cameraPosition - getShadowStableCameraOrigin();
}

vec3 worldToStableShadowRelative(vec3 worldPos) {
#if SHADOW_STABLE_SNAP > 0
    return worldPos + getShadowStableCameraOffset();
#else
    return worldPos;
#endif
}

vec3 getVoxelIndex(vec3 worldPos, float voxelSize) {
    vec3 absolutePos = worldRelativeToAbsolute(worldPos);
    return floor(absolutePos / voxelSize);
}

float getDominantAxisIndex(vec3 n) {
    vec3 an = abs(n);
    if (an.x > an.y && an.x > an.z) return 0.0;
    if (an.y > an.z) return 1.0;
    return 2.0;
}

void getCardinalFaceFrame(vec3 normal, out vec3 faceNormal, out vec3 tangent, out vec3 bitangent);

float encodeCardinalNormalToScalar(vec3 normal) {
    vec3 faceNormal;
    vec3 tangent;
    vec3 bitangent;
    getCardinalFaceFrame(normal, faceNormal, tangent, bitangent);

    if (faceNormal.x > 0.5) return (0.5 / 6.0);
    if (faceNormal.x < -0.5) return (1.5 / 6.0);
    if (faceNormal.y > 0.5) return (2.5 / 6.0);
    if (faceNormal.y < -0.5) return (3.5 / 6.0);
    if (faceNormal.z > 0.5) return (4.5 / 6.0);
    return (5.5 / 6.0);
}

vec3 decodeCardinalNormalFromScalar(float packedNormal) {
    float idx = floor(saturate(packedNormal) * 6.0);

    if (idx < 0.5) return vec3(1.0, 0.0, 0.0);
    if (idx < 1.5) return vec3(-1.0, 0.0, 0.0);
    if (idx < 2.5) return vec3(0.0, 1.0, 0.0);
    if (idx < 3.5) return vec3(0.0, -1.0, 0.0);
    if (idx < 4.5) return vec3(0.0, 0.0, 1.0);
    return vec3(0.0, 0.0, -1.0);
}

float getCardinalFaceIndex6(vec3 normal) {
    vec3 faceNormal;
    vec3 tangent;
    vec3 bitangent;
    getCardinalFaceFrame(normal, faceNormal, tangent, bitangent);

    if (faceNormal.x > 0.5) return 0.0;
    if (faceNormal.x < -0.5) return 1.0;
    if (faceNormal.y > 0.5) return 2.0;
    if (faceNormal.y < -0.5) return 3.0;
    if (faceNormal.z > 0.5) return 4.0;
    return 5.0;
}

void getCardinalFaceFrame(vec3 normal, out vec3 faceNormal, out vec3 tangent, out vec3 bitangent) {
    vec3 n = safeNormalize(normal);
    vec3 an = abs(n);

    if (an.x > an.y && an.x > an.z) {
        float sx = n.x >= 0.0 ? 1.0 : -1.0;
        faceNormal = vec3(sx, 0.0, 0.0);
        tangent = vec3(0.0, 0.0, -sx);
        bitangent = vec3(0.0, 1.0, 0.0);
    } else if (an.y > an.z) {
        float sy = n.y >= 0.0 ? 1.0 : -1.0;
        faceNormal = vec3(0.0, sy, 0.0);
        tangent = vec3(1.0, 0.0, 0.0);
        bitangent = vec3(0.0, 0.0, -sy);
    } else {
        float sz = n.z >= 0.0 ? 1.0 : -1.0;
        faceNormal = vec3(0.0, 0.0, sz);
        tangent = vec3(sz, 0.0, 0.0);
        bitangent = vec3(0.0, 1.0, 0.0);
    }
}

float orientFaceLocalCoord(float localCoord, float axisDir) {
    return axisDir >= 0.0 ? localCoord : 1.0 - localCoord;
}

float resolveFaceAxisCoord(float localU, float localV, float tangentAxis, float bitangentAxis) {
    if (abs(tangentAxis) > 0.5) {
        return orientFaceLocalCoord(localU, tangentAxis);
    }
    if (abs(bitangentAxis) > 0.5) {
        return orientFaceLocalCoord(localV, bitangentAxis);
    }
    return 0.5;
}

vec2 getFaceLocalUV(vec3 worldPos, vec3 normal) {
    vec3 absoluteWorldPos = worldRelativeToAbsolute(worldPos);
    vec3 faceNormal;
    vec3 tangent;
    vec3 bitangent;
    getCardinalFaceFrame(normal, faceNormal, tangent, bitangent);

    vec2 uv = vec2(
        dot(absoluteWorldPos, tangent),
        dot(absoluteWorldPos, bitangent)
    );
    return fract(uv);
}

vec2 getFaceTexelCoord(vec3 worldPos, vec3 normal) {
    // Coordenada contínua na face: sem quantização em células.
    vec2 uv = getFaceLocalUV(worldPos, normal);
    return uv * GI_TEXEL_GRID_SIZE;
}

float getFaceTexelIndex(vec3 worldPos, vec3 normal) {
    vec2 t = getFaceTexelCoord(worldPos, normal);
    // Índice contínuo: evita o salto entre células da antiga grade.
    return t.x + t.y * GI_TEXEL_GRID_SIZE + getCardinalFaceIndex6(normal) * GI_TEXEL_GRID_SIZE * GI_TEXEL_GRID_SIZE;
}

vec3 getFaceTexelVoxelCenter(vec3 worldPos, vec3 normal) {
    vec3 faceNormal;
    vec3 tangent;
    vec3 bitangent;
    getCardinalFaceFrame(normal, faceNormal, tangent, bitangent);

    vec2 local = getFaceLocalUV(worldPos, faceNormal);
    // Recuar para dentro da face receptora mantem cada face presa ao seu proprio bloco.
    vec3 blockBase = getBlockAnchoredVoxelIndex(worldPos - faceNormal * GI_FACE_BLOCK_EPSILON);
    vec3 p = blockBase + vec3(0.5);

    p.x = blockBase.x + resolveFaceAxisCoord(local.x, local.y, tangent.x, bitangent.x);
    p.y = blockBase.y + resolveFaceAxisCoord(local.x, local.y, tangent.y, bitangent.y);
    p.z = blockBase.z + resolveFaceAxisCoord(local.x, local.y, tangent.z, bitangent.z);

    if (abs(faceNormal.x) > 0.5) {
        p.x = blockBase.x + (faceNormal.x > 0.0 ? 1.0 - GI_VOXEL_FACE_DEPTH : GI_VOXEL_FACE_DEPTH);
    }
    if (abs(faceNormal.y) > 0.5) {
        p.y = blockBase.y + (faceNormal.y > 0.0 ? 1.0 - GI_VOXEL_FACE_DEPTH : GI_VOXEL_FACE_DEPTH);
    }
    if (abs(faceNormal.z) > 0.5) {
        p.z = blockBase.z + (faceNormal.z > 0.0 ? 1.0 - GI_VOXEL_FACE_DEPTH : GI_VOXEL_FACE_DEPTH);
    }

    return worldAbsoluteToRelative(p);
}

vec3 cosineHemisphereDirection(vec3 normal, vec3 randomPairSeed) {
    vec3 n = safeNormalize(normal);
    vec3 tangent = safeNormalize(abs(n.y) < 0.999 ? cross(vec3(0.0, 1.0, 0.0), n) : cross(vec3(1.0, 0.0, 0.0), n));
    vec3 bitangent = cross(n, tangent);

    vec2 xi = hash23(randomPairSeed);
    float phi = TAU * xi.x;
    float r = sqrt(xi.y);
    float x = cos(phi) * r;
    float y = sin(phi) * r;
    float z = sqrt(max(0.0, 1.0 - xi.y));

    return safeNormalize(tangent * x + bitangent * y + n * z);
}

vec3 getStableJitter3(vec3 seed) {
    vec2 h = hash23(seed);
    float hz = hash13(seed + vec3(7.31, 17.17, 29.29));
    return vec3(h, hz) * 2.0 - 1.0;
}

vec3 getDeterministicHemisphereDirection(int rayIndex, vec3 normal, vec3 patternSeed) {
    vec3 faceNormal;
    vec3 tangent;
    vec3 bitangent;
    getCardinalFaceFrame(normal, faceNormal, tangent, bitangent);

    if (rayIndex <= 0) {
        return faceNormal;
    }

    const float GOLDEN_ANGLE = 2.39996322973;
    float fi = float(rayIndex - 1);
    float count = max(float(GI_RAY_COUNT - 1), 1.0);
    vec2 seedHash = hash23(patternSeed + faceNormal * 1.37 + vec3(3.11, 7.23, 11.47));
    float seedHashZ = hash13(patternSeed + faceNormal * 2.41 + vec3(13.17, 19.41, 23.57));
    float rotation = seedHash.x * TAU;

    // Distribuição hemisférica mais uniforme e menos alinhada com um único eixo.
    float t = (fi + 0.5) / count;
    float radial = sqrt(clamp(t, 0.0, 1.0));
    radial = mix(radial, min(radial + seedHash.y * 0.12, 0.995), 0.35);
    float angle = rotation + GOLDEN_ANGLE * fi + seedHash.y * 0.75;

    vec2 disk = vec2(cos(angle), sin(angle)) * radial;
    float up = sqrt(max(0.0, 1.0 - dot(disk, disk)));
    vec3 dir = safeNormalize(faceNormal * up + tangent * disk.x + bitangent * disk.y);

    // Mantém o comportamento parecido, mas reduz o padrão repetido entre raios.
    return safeNormalize(mix(dir, faceNormal, 0.06 + seedHashZ * 0.04));
}

vec3 getStableVoxelSampleAnchor(vec3 worldPos, vec3 normal) {
    vec3 faceNormal;
    vec3 tangent;
    vec3 bitangent;
    getCardinalFaceFrame(normal, faceNormal, tangent, bitangent);
    vec3 anchor = getFaceTexelVoxelCenter(worldPos, faceNormal);
    return anchor + faceNormal * (GI_SURFACE_PUSH + GI_NORMAL_BIAS);
}

vec2 worldToPreviousScreen(vec3 currentPlayerSpacePos) {
    // currentPlayerSpacePos esta relativo a camera atual. Para reprojectar,
    // reconstrui a mesma posicao no espaco relativo da camera anterior.
    vec3 previousPlayerSpacePos = currentPlayerSpacePos + (cameraPosition - previousCameraPosition);
    vec4 previousView = gbufferPreviousModelView * vec4(previousPlayerSpacePos, 1.0);
    vec4 previousClip = gbufferPreviousProjection * previousView;
    vec2 previousNdc = previousClip.xy / max(previousClip.w, EPSILON);
    return previousNdc * 0.5 + 0.5;
}

bool isUvInsideScreen(vec2 uv) {
    return uv.x > 0.0 && uv.x < 1.0 && uv.y > 0.0 && uv.y < 1.0;
}

#endif
