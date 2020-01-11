const map = (value, x1, y1, x2, y2) => (value - x1) * (y2 - x2) / (y1 - x1) + x2;

async function OnLoad () {
    var w = canvas.width  = Math.min (window.innerWidth, window.innerHeight);
    var h = canvas.height = Math.min (window.innerWidth, window.innerHeight);
    var gl = canvas.getContext("webgl");

    var vsource = await (await fetch ("vsource.vs")).text ();
    var vs = gl.createShader (gl.VERTEX_SHADER);
    gl.shaderSource (vs, vsource);
    gl.compileShader (vs);
    if (!gl.getShaderParameter (vs, gl.COMPILE_STATUS)) {
        console.error ("VS Error:", gl.getShaderInfoLog (vs));
        return;
    }

    var fsource = await (await fetch ("fsource.fs")).text ();
    var fs = gl.createShader (gl.FRAGMENT_SHADER);
    gl.shaderSource (fs, fsource);
    gl.compileShader (fs);
    if (!gl.getShaderParameter (fs, gl.COMPILE_STATUS)) {
        console.error ("FS Error:", gl.getShaderInfoLog (fs));
        return;
    }

    var prog = gl.createProgram ();
    gl.attachShader (prog, vs);
    gl.attachShader (prog, fs);
    gl.linkProgram (prog);
    if (!gl.getProgramParameter (prog, gl.LINK_STATUS)) {
        console.error ("Program Linking Error:", gl.getProgramInfoLog (prog));
        return;
    }
    gl.validateProgram (prog);
    if (!gl.getProgramParameter (prog, gl.VALIDATE_STATUS)) {
        console.error ("Program Validating Error:", gl.getProgramInfoLog (prog));
        return;
    }
    gl.useProgram (prog);

    var size = w * h * 2;
    var vert = new Float32Array (w * h * 2);
    for (var i = 0, x = 0, y = 0; i < size; i += 2, (x = (x + 1) % w) || ++y) {
        vert[i    ] = map (x, 0, w, -1, 1);
        vert[i + 1] = map (y, 0, h, -1, 1);
    }

    var buff = gl.createBuffer ();
    gl.bindBuffer (gl.ARRAY_BUFFER, buff);
    gl.bufferData (gl.ARRAY_BUFFER, vert, gl.STATIC_DRAW);

    var a_pos = gl.getAttribLocation (prog, "a_pos");
    gl.vertexAttribPointer (a_pos, 2, gl.FLOAT, false, 0, 0);
    gl.enableVertexAttribArray (a_pos);

    var u_time = gl.getUniformLocation (prog, "u_time");
    gl.uniform1f (u_time, 1.0);

    // Finally
    var t = 1.0;

    setInterval (function () {
        gl.uniform1f (u_time, t += 0.1);

        gl.clearColor(0.2, 0.5, 0.75, 1.0);
        gl.enable(gl.DEPTH_TEST); 
        gl.clear(gl.COLOR_BUFFER_BIT);
        gl.viewport(0, 0, w, h);
        gl.drawArrays (gl.POINTS, 0, w * h);
    }, 40);
}