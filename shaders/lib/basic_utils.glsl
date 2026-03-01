/* MakeUp - E-LITE shaders 5 - basic_utils.glsl
Misc utilities.

Javier Garduño - GNU Lesser General Public License v3.0
*/

float square_pow(float x) {
    return x * x;
}

float cube_pow(float x) {
    return x * x * x;
}

float fourth_pow(float x) {
    float temp_2 = x * x;
    return temp_2 * temp_2;
}

float fifth_pow(float x) {
    float temp_2 = x * x;
    return temp_2 * temp_2 * x;
}

float sixth_pow(float x) {
    float temp_2 = x * x;
    return temp_2 * temp_2 * temp_2;
}

vec3 vec3_square_pow(vec3 x) {
    return x * x;
}

vec3 vec3_cube_pow(vec3 x) {
    return x * x * x;
}

vec3 vec3_fourth_pow(vec3 x) {
    vec3 temp_2 = x * x;
    return temp_2 * temp_2;
}

vec3 vec3_fifth_pow(vec3 x) {
    vec3 temp_2 = x * x;
    return temp_2 * temp_2 * x;
}

vec3 vec3_sixth_pow(vec3 x) {
    vec3 temp_2 = x * x;
    return temp_2 * temp_2 * temp_2;
}

vec4 vec4_square_pow(vec4 x) {
    return x * x;
}

vec4 vec4_cube_pow(vec4 x) {
    return x * x * x;
}

vec4 vec4_fourth_pow(vec4 x) {
    return x * x * x * x;
}

vec4 vec4_fifth_pow(vec4 x) {
    vec4 temp_2 = x * x;
    return temp_2 * temp_2 * x;
}

vec4 vec4_sixth_pow(vec4 x) {
    vec4 temp_2 = x * x;
    return temp_2 * temp_2 * temp_2;
}

float fastpow(float base, float p) {
    int exp = int(p);
    float res = 1.0;
    float b = base;

    /* fastpow - E-LITE 5
    The power of example is 6.
    | STEP | MASK  | BINARY (6) | MATCH? | ACTION
    | 1    | & 1   | 110 & 001  | NO     | skip
    | 2    | & 2   | 110 & 010  | YES    | 1.0 *= b
    | 3    | & 4   | 110 & 100  | YES    | 1.0 *= b^4

    b^2 * b^4 = b^6
    */

    if ((exp & 1) != 0) res *= b; b *= b;
    if ((exp & 2) != 0) res *= b; b *= b;
    if ((exp & 4) != 0) res *= b; b *= b;
    if ((exp & 8) != 0) res *= b; b *= b;
    if ((exp & 16) != 0) res *= b; b *= b;
    if ((exp & 32) != 0) res *= b;

    float f = fract(p);
    res *= mix(1.0, sqrt(base), step(0.4, f));

    return res;
}

vec2 fastpow2(vec2 b, float p) {
    return vec2(fastpow(b.x, p), fastpow(b.y, p));
}

vec3 fastpow3(vec3 b, float p) {
    return vec3(fastpow(b.x, p), fastpow(b.y, p), fastpow(b.z, p));
}

vec4 fastpow4(vec4 b, float p) {
    return vec4(fastpow(b.x, p), fastpow(b.y, p), fastpow(b.z, p), fastpow(b.w, p));
}