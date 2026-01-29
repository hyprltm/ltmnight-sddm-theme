// LTMNight Aurora Shader
#version 440

layout(location = 0) in vec2 qt_TexCoord0;
layout(location = 0) out vec4 fragColor;

layout(std140, binding = 0) uniform buf {
    mat4 qt_Matrix;
    float qt_Opacity;
    float time;
    vec2 resolution;
    vec4 bg;
    vec4 accent;
} ubuf;

// --- UTILS ---
float hash(vec2 p) {
    return fract(sin(dot(p, vec2(12.9898, 78.233))) * 43758.5453);
}

float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    f = f * f * (3.0 - 2.0 * f);
    return mix(mix(hash(i + vec2(0.0, 0.0)), hash(i + vec2(1.0, 0.0)), f.x),
               mix(hash(i + vec2(0.0, 1.0)), hash(i + vec2(1.0, 1.0)), f.x), f.y);
}

float fbm(vec2 p) {
    float v = 0.0;
    float a = 0.5;
    mat2 rot = mat2(cos(0.5), sin(0.5), -sin(0.5), cos(0.5));
    for (int i = 0; i < 4; i++) { 
        v += a * noise(p);
        p = rot * p * 2.0; 
        a *= 0.5;
    }
    return v;
}

// --- LAYERS ---
vec4 cometLayer(vec2 uv, float seed, float time) {
    vec2 grid = uv * 1.5; 
    vec2 id = floor(grid);
    vec2 f = fract(grid);
    float rnd = hash(id + seed); 
    
    float t = time * (0.15 + rnd * 0.15) + rnd * 100.0;
    float cycle = fract(t); 
    
    float isActive = smoothstep(0.0, 0.1, cycle) * smoothstep(0.3, 0.0, cycle);
    if (isActive <= 0.001) return vec4(0.0);
    
    vec2 p = f - 0.5;
    float distFromCenter = length(p);
    float mask = smoothstep(0.5, 0.3, distFromCenter); 
    if (mask <= 0.001) return vec4(0.0);

    float u = (p.x + p.y) * 0.707;
    float v = (p.y - p.x) * 0.707;
    float pos = mix(1.2, -1.2, cycle * 3.0); 
    float d = length(vec2(u - pos, v));
    
    float head = 0.03 / (d + 0.005);
    float tailLen = (u - pos);
    float tail = 0.0;
    if (tailLen > 0.0) {
        tail = exp(-tailLen * 3.0) * exp(-abs(v) * 30.0);
    }
    float intensity = (head + tail * 0.8) * isActive * mask;
    
    vec3 col = mix(vec3(1.0, 0.9, 1.0), vec3(0.75, 0.4, 1.0), clamp(tailLen * 1.5, 0.0, 1.0));
    return vec4(col * intensity, intensity);
}

float starLayer(vec2 uv, float scale, float seed, float t) {
    vec2 grid = uv * scale;
    vec2 id = floor(grid);
    vec2 f = fract(grid);
    float rnd = hash(id + seed);
    if (rnd > 0.1) return 0.0; 
    vec2 center = 0.5 + (vec2(hash(id + seed * 2.0), hash(id + seed * 3.0)) - 0.5) * 0.8;
    float d = length(f - center);
    float radius = 0.02 + rnd * 0.03;
    float mask = 1.0 - step(0.4, d); 
    float twinkle = 0.5 + 0.5 * sin(t * 2.0 + rnd * 50.0);
    float glow = 0.01 / (d + 0.05); 
    return (smoothstep(radius, radius * 0.5, d) + glow) * twinkle * mask;
}

void main() {
    vec2 uv = (gl_FragCoord.xy - 0.5 * ubuf.resolution.xy) / ubuf.resolution.y;
    float t = ubuf.time * 0.12; 
    
    // Background
    vec3 bgDeep = vec3(0.00, 0.00, 0.00); 
    vec3 bgMid = vec3(0.02, 0.01, 0.03); 
    vec3 col = mix(bgDeep, bgMid, uv.y + 0.6); 

    // Aurora
    float aurora = 0.0;
    
    for (float i = 0.0; i < 4.0; i++) {
        float drift = t * 0.1 + i * 15.0; 
        
        float warp = noise(uv * vec2(0.3, 0.3) + vec2(drift, t * 0.1));
        
        vec2 auv = uv;
        auv.x += warp * 1.0; 
        
        float ray_noise = fbm(auv * vec2(1.0, 0.2) + vec2(drift * 0.5, t * 0.3 + i * 0.2));
        
        float y_base = -0.3;  
        float distH = auv.y - y_base;
        
        float vertical_shape = smoothstep(0.0, 0.3, distH) * smoothstep(0.8, 0.2, distH);
        
        float dispersion = noise(auv * 5.0 + vec2(0.0, t * 2.0));
        
        float density = smoothstep(0.2, 0.8, ray_noise);
        density *= (0.5 + 0.5 * dispersion);
        
        aurora += vertical_shape * density * (0.35 + i * 0.1);
    }
    
    // Gradient Mixing
    float global_warp = noise(uv * 0.6 + vec2(t * 0.1)); 
    float g = uv.y + 0.5 + global_warp * 0.15; 
    
    vec3 cDeep = vec3(0.2, 0.05, 0.4); 
    vec3 cPink = vec3(0.6, 0.2, 0.6);
    vec3 cCyan = vec3(0.0, 0.8, 0.8);
    vec3 cGreen = vec3(0.31, 0.98, 0.48);
    
    vec3 auroraCol = mix(cDeep, cPink, smoothstep(0.0, 0.6, g));
    auroraCol = mix(auroraCol, cCyan, smoothstep(0.4, 0.8, g));
    auroraCol = mix(auroraCol, cGreen, smoothstep(0.6, 1.0, g));
    
    col += auroraCol * aurora * 0.9; 

    // Stars
    float stars = 0.0;
    stars += starLayer(uv, 15.0, 10.0, t); 
    float auroraBright = length(col);
    col += vec3(0.9) * stars * (1.0 - smoothstep(0.1, 0.5, auroraBright));

    // Comets
    vec4 comet1 = cometLayer(uv, 42.0, t);
    vec4 comet2 = cometLayer(uv + 0.5, 99.0, t * 1.1);
    col += comet1.rgb;
    col += comet2.rgb;

    fragColor = vec4(col, 1.0) * ubuf.qt_Opacity;
}
