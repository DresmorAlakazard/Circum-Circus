precision lowp float;

uniform float u_time;
varying vec3 v_color;
attribute vec2 a_pos;

const int max_iterations = 256;
const float color_fades = 10.0;

bool incc (in float x, in float y, in float r) {
    return pow ((mod (x, 2.0 * r) - r), 2.0) + pow (y, 2.0) <= pow (r, 2.0);
}

int minn (in float y) {
    return int (log (abs (y)) / log (2.0));
}

void iter (in float x, in float y, inout int n) {
    for (int i = 0; i < max_iterations; i++) {
        if (incc (x, y, pow (2.0, float (n)))) {
            break;
        }
        n++;
    }
}

void rotxy (inout float x, inout float y, in float d) {
    float r = radians (d);
    float c = cos (r);
    float s = sin (r);

    float newx = x * c - y * s;
    float newy = x * s + y * c;
    
    x = newx;
    y = newy;
}

void main (void) {
    gl_Position = vec4 (a_pos, 0.0, 1.0);
    gl_PointSize = 1.0;

    float x = a_pos.x;
    float y = a_pos.y;

    #if 1
    x *= 1.0 / pow (2.0, mod (u_time * radians (180.0), color_fades));
    y *= 1.0 / pow (2.0, mod (u_time * radians (180.0), color_fades));
    #endif

    #if 0
    x *= pow (2.0, 16.0 * (sin (radians (u_time * 33.0)) * 0.5 + 1.0));
    y *= pow (2.0, 16.0 * (sin (radians (u_time * 33.0)) * 0.5 + 1.0));

    x *= tan (y) / sin (x);
    #endif

    #if 0
    x *= pow(2.0, 1.0 + 31.0 * (1.0 + 0.5 * sin (radians (u_time))));
    y *= pow(2.0, 1.0 + 31.0 * (1.0 + 0.5 * sin (radians (u_time))));

    rotxy (x, y, 45.0 * u_time);

    x *= sin (radians ( mod (y * 42342.0   * pow (2.0, mod (u_time, 30.0)), float (0xfff)) ));
    y *= sin (radians ( mod (y * 2424224.0 * pow (2.0, mod (u_time, 30.0)), float (0xfff)) ));
    #endif 

    int n = minn (y);

    iter (x, y, n);

    v_color.r = mod (float (n) / color_fades, 1.0);
    v_color.g = mod (log (v_color.r) / log (31.0), 1.0);
    v_color.b = mod (pow(6.0, v_color.r), 1.0);
}