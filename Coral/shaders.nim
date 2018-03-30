## Non Instanced Shader
const SPRITE_SHADER_VERTEX* = """
#version 330 core
layout (location = 0) in vec2 Vertex;

out vec2 uvs;
out vec4 color;

uniform vec2 position;
uniform vec2 size;
uniform float rotation = 0.0;
uniform float depth = 0.5;

uniform vec4 quad;
uniform mat2 view;
uniform mat4 ortho;
uniform vec4 diffuse;

void main() {
    vec2 tuvs = Vertex * 1.0 + 0.5;
    tuvs.y = 1 - tuvs.y;

    uvs.x = (quad.x + (tuvs.x * quad.z));
    uvs.y = (quad.y + (tuvs.y * quad.w));

    color = diffuse;
  
    float s = sin(rotation);
    float c = cos(rotation);
    mat2 rot = mat2(c, -s, s, c);
    vec2 pos = position + (size * ((rot * Vertex) + 0.5));
    gl_Position = ortho * vec4(pos, 0.0, 1.0) + vec4(0, 0, depth, 0.0);
}
"""

const SPRITE_SHADER_FRAGMENT* = """
#version 330 core

in vec2 uvs;
in vec4 color;

uniform bool has_texture = true;
uniform sampler2D sampler;
void main() {
  vec4 result = vec4(0.0);
	if (has_texture){
		result = color * texture(sampler, uvs);
	} else {
		result = color;
	}
  
  if (result.a <= 0.1) discard;
  gl_FragColor = result;
}
"""

## Instanced Vertex Shader
const SPRITE_SHADER_VERTEX_INSTANCED* = """
#version 330 core
layout (location = 0) in vec2 Vertex;
layout (location = 1) in vec4 rectangle;
layout (location = 2) in vec2 rot_and_depth;
layout (location = 3) in vec4 quad;
layout (location = 4) in vec4 diffuse;

out vec2 uvs;
out vec4 color;

uniform mat2 view;
uniform mat4 ortho;

void main() {
    vec2 position   = rectangle.xy;
    vec2 size       = rectangle.zw;
    float rotation  = rot_and_depth.x;
    float depth     = rot_and_depth.y;

    color = diffuse;

    vec2 tuvs = Vertex * 1.0 + 0.5;
    tuvs.y = 1 - tuvs.y;

    uvs.x = (quad.x + (tuvs.x * quad.z));
    uvs.y = (quad.y + (tuvs.y * quad.w));
  
    float s = sin(rotation);
    float c = cos(rotation);
    mat2 rot = mat2(c, -s, s, c);
    vec2 pos = position + (size * ((rot * Vertex) + 0.5));
    gl_Position = ortho * vec4(pos, 0.0, 1.0) + vec4(0, 0, depth, 0.0);
}
"""