precision lowp float;

uniform float u_time;
uniform vec2 u_aspect;
varying vec3 v_color;
attribute vec2 a_pos;

void main (void) {
    gl_Position = vec4 (a_pos, 0.0, 1.0);
    gl_PointSize = 1.0;

    float x = a_pos.x * u_aspect.x;
    float y = a_pos.y * u_aspect.y;
    
    float t = u_time * .5;

    x /= pow (2.0, mod (t, 2.0));
    y /= pow (2.0, mod (t, 2.0));
    
    float n = floor (log (abs (y)) / log (2.0));

    for (int i = 0; i < 256; i++) {
        float r = pow (2.0, n);
        if (pow (mod (x, 2.0 * r) - r, 2.0) + pow (y, 2.0) <= pow (r, 2.0)) {
            break;
        }
        n++;
    }

    n -= floor (t / 2.0) * 2.0;
    
    v_color.r = mod (n / 33.0, 1.0);
    v_color.g = mod (n / 22.0, 1.0);
    v_color.b = mod (n / 11.0, 1.0);
}
