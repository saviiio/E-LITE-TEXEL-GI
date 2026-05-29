#ifndef E_LITE_INDIRECT_SHADOW_SHARED_GLSL
#define E_LITE_INDIRECT_SHADOW_SHARED_GLSL

#include "/lib/indirect_common.glsl"

#ifdef USE_ENTITY_COLOR
uniform vec4 entityColor;
#endif

#ifdef SHADOW_VERTEX
varying vec2 vShadowTexCoord;
varying vec4 vShadowVertexColor;
varying vec3 vShadowWorldPos;
varying vec3 vShadowWorldNormal;
#endif

#ifdef SHADOW_FRAGMENT
varying vec2 vShadowTexCoord;
varying vec4 vShadowVertexColor;
varying vec3 vShadowWorldPos;
varying vec3 vShadowWorldNormal;
uniform sampler2D gtexture;
#define shadowColorOut gl_FragData[0]
#endif

#ifndef SHADOW_ALPHA_TEST_REF
#define SHADOW_ALPHA_TEST_REF 0.001
#endif

#ifndef SHADOW_DISTORTION_BIAS
#define SHADOW_DISTORTION_BIAS 0.10
#endif
float getShadowMapTexelSize() {
    return 1.0 / float(shadowMapResolution);
}

vec2 getShadowMapTexel() {
    return vec2(getShadowMapTexelSize());
}

vec3 distortShadowClipPos(vec3 shadowClipPos) {
    float radialDistance = length(shadowClipPos.xy);
    float distortionFactor = mix(1.0, radialDistance + SHADOW_DISTORTION_BIAS, SHADOW_RADIAL_DISTORTION);
    shadowClipPos.xy /= max(distortionFactor, 0.10);
    shadowClipPos.z *= (1.0 - SHADOW_Z_COMPRESSION);
    return shadowClipPos;
}

vec3 getWorldShadowLightDirection() {
    return safeNormalize(mat3FromMat4(gbufferModelViewInverse) * shadowLightPosition);
}

float getShadowHorizonFactor(vec3 normal, vec3 lightDir) {
    return saturate(dot(normal, lightDir) * 0.85 + 0.15);
}

float getSunFacingContribution(vec3 normal, vec3 lightDir) {
    return saturate(dot(normal, lightDir));
}

vec3 getAdaptiveShadowNormalOffset(vec3 normal, vec3 lightDir) {
    float ndotl = 1.0 - saturate(dot(normal, lightDir));
    return normal * (SHADOW_NORMAL_OFFSET * (0.35 + ndotl));
}

float getAdaptiveShadowReceiverBias(vec3 normal, vec3 lightDir) {
    return SHADOW_MAP_BIAS;
}

vec3 projectWorldToShadowClipWithBias(vec3 worldPos, float bias) {
    vec3 stableWorldPos = worldToStableShadowRelative(worldPos);
    vec3 shadowView = (shadowModelView * vec4(stableWorldPos, 1.0)).xyz;
    vec4 shadowClip = shadowProjection * vec4(shadowView, 1.0);

    // Bias aplicado no espaco de clip antes da distorcao, conforme o fluxo da documentacao do Iris.
    shadowClip.z -= bias;
    shadowClip.xyz = distortShadowClipPos(shadowClip.xyz);
    return shadowClip.xyz / max(shadowClip.w, EPSILON);
}

vec3 stabilizeShadowTexcoord(vec3 stc) {
#if SHADOW_STABLE_TEXEL_SNAP > 0
    float texelSize = getShadowMapTexelSize();
    stc.xy = (floor(stc.xy / texelSize) + 0.5) * texelSize;
#endif
    return stc;
}

vec3 projectWorldToShadowClip(vec3 worldPos) {
    return projectWorldToShadowClipWithBias(worldPos, 0.0);
}

vec3 projectWorldToShadowTexcoord(vec3 worldPos) {
    vec3 clip = projectWorldToShadowClip(worldPos);
    return stabilizeShadowTexcoord(clip * 0.5 + 0.5);
}

vec3 projectWorldToBiasedShadowTexcoord(vec3 worldPos) {
    vec3 clip = projectWorldToShadowClipWithBias(worldPos, SHADOW_MAP_BIAS);
    return stabilizeShadowTexcoord(clip * 0.5 + 0.5);
}

#ifdef SAMPLE_SHADOW_RUNTIME
#ifndef E_LITE_INDIRECT_EXTERNAL_SHADOW_SAMPLERS
uniform sampler2DShadow shadowtex0;
uniform sampler2DShadow shadowtex1;
uniform sampler2D shadowcolor0;
#endif

bool isValidShadowTexcoord(vec3 stc) {
    float border = 1.5 * getShadowMapTexelSize();
    return stc.x > border && stc.x < 1.0 - border &&
           stc.y > border && stc.y < 1.0 - border &&
           stc.z > 0.0 && stc.z < 1.0;
}

float sampleShadowDepthAllRaw(vec2 uv) {
    return 1.0;
}

float sampleShadowDepthOpaqueRaw(vec2 uv) {
    return 1.0;
}

float sampleShadowDepthCompare(vec3 stc, vec2 offset) {
    vec3 sampleCoord = vec3(stc.xy + offset, stc.z);
    if (!isValidShadowTexcoord(sampleCoord)) {
        return 1.0;
    }
    return shadow2D(shadowtex1, sampleCoord).r;
}

float sampleShadowCompare(vec3 stc) {
    if (!isValidShadowTexcoord(stc)) {
        return 1.0;
    }

#if SHADOW_FILTER_MODE <= 0
    return sampleShadowDepthCompare(stc, vec2(0.0));
#else
    vec2 texel = getShadowMapTexel() * SHADOW_PCF_RADIUS;
    float sum = 0.0;

    for (int x = 0; x < 2; ++x) {
        for (int y = 0; y < 2; ++y) {
            vec2 offset = (vec2(float(x), float(y)) - 0.5) * texel;
            sum += sampleShadowDepthCompare(stc, offset);
        }
    }

    return sum * 0.25;
#endif
}

float sampleShadowMaskAt(vec3 receiverPos, vec3 normal, vec3 lightDir) {
    vec3 biasedReceiver = receiverPos + getAdaptiveShadowNormalOffset(normal, lightDir);
    vec3 stc = projectWorldToBiasedShadowTexcoord(biasedReceiver);
    return sampleShadowCompare(stc);
}

float sampleShadowMask(vec3 worldPos, vec3 normal) {
    vec3 n = safeNormalize(normal);
    vec3 lightDir = getWorldShadowLightDirection();

    // Faces voltadas para longe da luz direta devem permanecer sem luz direta.
    if (dot(n, lightDir) <= 0.0) {
        return 0.0;
    }

    // Sombra tradicional: projeta o receptor no shadow map e compara profundidade.
    // O bias fixo e SHADOW_MAP_BIAS = 0.0025 por padrao.
    return sampleShadowMaskAt(worldPos, n, lightDir);
}

float sampleHtmlHardShadowMask(vec3 worldPos, vec3 normal) {
    return sampleShadowMask(worldPos, normal);
}

float getShadowedLightContribution(vec3 worldPos, vec3 normal) {
    vec3 lightDir = getWorldShadowLightDirection();
    float facing = getSunFacingContribution(normal, lightDir);
    float visible = sampleShadowMask(worldPos, normal);
    return facing * visible;
}

vec4 sampleShadowMaterialInfo(vec3 worldPos) {
    vec3 stc = projectWorldToShadowTexcoord(worldPos);
    if (!isValidShadowTexcoord(stc)) {
        return vec4(0.0);
    }
    return texture2D(shadowcolor0, stc.xy);
}

vec4 sampleShadowMaterialInfoStable(vec3 worldPos) {
    vec3 stc = projectWorldToShadowTexcoord(worldPos);
    if (!isValidShadowTexcoord(stc)) {
        return vec4(0.0);
    }

    if (sampleShadowCompare(stc) <= 0.01) {
        return vec4(0.0);
    }

    float texelSize = getShadowMapTexelSize();
    vec2 stableUv = (floor(stc.xy / texelSize) + 0.5) * texelSize;
    vec4 info = texture2D(shadowcolor0, stableUv);
    if (maxComponent(info.rgb) <= GI_MIN_ENERGY) {
        return vec4(0.0);
    }
    return info;
}
#endif

#ifdef SHADOW_VERTEX
vec4 getShadowVertexColor() {
    vec4 tint = stripVanillaShadingKeepTint(gl_Color);
#ifdef USE_ENTITY_COLOR
    tint.rgb = mix(tint.rgb, entityColor.rgb, entityColor.a);
#endif
    return tint;
}

vec4 getStableShadowPassClipPosition(vec4 shadowViewPos) {
#if SHADOW_STABLE_SNAP > 0
    // O shadow pass tambem precisa usar a mesma origem estavel da amostragem.
    // Antes, apenas projectWorldToShadowClipWithBias() aplicava
    // worldToStableShadowRelative(); o mapa era gravado com a matriz movendo
    // junto com a camera. Isso fazia a sombra deslizar quando o jogador andava.
    vec3 worldPos = (shadowModelViewInverse * shadowViewPos).xyz;
    vec3 stableWorldPos = worldToStableShadowRelative(worldPos);
    vec4 stableShadowViewPos = shadowModelView * vec4(stableWorldPos, 1.0);
    return shadowProjection * stableShadowViewPos;
#else
    return gl_ProjectionMatrix * shadowViewPos;
#endif
}

void main() {
    vShadowTexCoord = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;
    vShadowVertexColor = getShadowVertexColor();

    vec4 localVertex = gl_Vertex + vec4(safeNormalize(gl_Normal) * SHADOW_PASS_NORMAL_OFFSET, 0.0);
    vec4 shadowViewPos = gl_ModelViewMatrix * localVertex;
    vShadowWorldPos = (shadowModelViewInverse * shadowViewPos).xyz;
    vShadowWorldNormal = safeNormalize(mat3FromMat4(shadowModelViewInverse) * (gl_NormalMatrix * gl_Normal));

    gl_Position = getStableShadowPassClipPosition(shadowViewPos);
    gl_Position.xyz = distortShadowClipPos(gl_Position.xyz);
}
#endif

#ifdef SHADOW_FRAGMENT
vec4 sampleShadowAlbedo() {
    vec4 texel = texture2D(gtexture, vShadowTexCoord);
    return vec4(applyFaceAwareVertexTint(texel.rgb, vShadowVertexColor.rgb), texel.a * vShadowVertexColor.a);
}

vec3 getShadowSurfaceTint(vec3 albedo) {
#ifdef WATER_SHADOW
    albedo *= vec3(0.60, 0.85, 1.00);
#endif
    return albedo;
}

void main() {
    vec4 base = sampleShadowAlbedo();

    if (base.a < SHADOW_ALPHA_TEST_REF) {
        discard;
    }

    vec3 normal = safeNormalize(vShadowWorldNormal);
    vec3 lightDir = getWorldShadowLightDirection();
    float facing = getSunFacingContribution(normal, lightDir);
    float horizon = getShadowHorizonFactor(normal, lightDir);
    float visibleToLight = facing * horizon;

    vec3 injected = vec3(0.0);
    float packedReflectorNormal = 0.0;

    if (visibleToLight > EPSILON) {
        vec3 albedo = getShadowSurfaceTint(base.rgb);
        float rainDim = mix(1.0, 0.55, rainStrength);
        injected = sanitizeColor(albedo * visibleToLight * GI_ENERGY_GAIN * rainDim);

        if (maxComponent(injected) > GI_MIN_ENERGY) {
            packedReflectorNormal = encodeCardinalNormalToScalar(normal);
        } else {
            injected = vec3(0.0);
        }
    }

    shadowColorOut = vec4(injected, packedReflectorNormal);
}
#endif

#endif
