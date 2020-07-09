#pragma once

#include <kgfx/ShaderUtil.hpp>

#include <glad/glad.h>
#include <GLFW/glfw3.h>

inline struct rect_program_ {

struct attrib_ {
  constexpr static GLuint vertex_position = 0;
  constexpr static GLuint instance_offset = 1;
  constexpr static GLuint instance_color  = 2;
  constexpr static GLuint instance_z      = 3;
} attrib;

GLuint VAO; // array object

struct buffer_ {
  GLuint vertex; // VBO vertex buffer object
  GLuint element; // EBO vertex elements object
  GLuint instance; // IBO instance buffer object
} buffer;

// shaders

ShaderSource sources {
  .vertex =
R"zzz(#version 460 core

// input attribute from render
layout (location = 0) in vec2 vertex_position;

// input attribute from instances
layout (location = 1) in vec4 instance_rect;
layout (location = 2) in vec4 instance_color;
layout (location = 3) in float instance_z;

// output to geometry shader
out vec4 vec_color;
// out vec4 gl_Position;

/* note: expanded for clarity, equivalent to:
 *   gl_Position = vec4(instance_rect.xy + (instance.rect.zw * vertex_position), 0, 1);
 */
void main()
{
  float dx = instance_rect.z;
  float dy = instance_rect.w;

  // scale the vertex to the right position
  vec2 pos = vertex_position * vec2(dx, dy);

  vec2 top_left = instance_rect.xy;
  gl_Position = vec4(pos + top_left, instance_z, 1);

  vec_color = instance_color;
}
)zzz",

  .geometry =
R"zzz(#version 460 core

// layout description between vertex and fragment shader
layout (triangles) in;
layout (triangle_strip, max_vertices = 4) out;

// input from vertex shader
in vec4 vec_color[];

// pass along to fragment shader
flat out vec4 frag_color;

// output to fragment shader
out vec4 position;
// out vec4 gl_Position

uniform mat4 projection;

//
//  A  D     A--D         2--3
//  |\    -> |\ |  order: |\ |  order is for triangle_strip,
//  | \      | \|         | \|  so C B A D
//  C--B     C--B         0--1
//
// this triangle_strip order swaps 1 and 2 because we're using an orthographic
// projection that starts from a right-handed system to screen-space's left-handed system
// - i.e. the ortho handedness swap requires 1 and 2 to be swapped

void main()
{
  frag_color = vec_color[0];

	vec3 A = gl_in[0].gl_Position.xyz;
	vec3 B = gl_in[1].gl_Position.xyz;
	vec3 C = gl_in[2].gl_Position.xyz;
  vec3 D = A + (B - C);

	// perimeter = 2*length(A - B) + 2*length(B - C);

  // TODO z-ordering before and after the ortho proj is flipped
  position = gl_Position = projection * vec4(C.xy, -C.z, 1); EmitVertex();
  position = gl_Position = projection * vec4(B.xy, -B.z, 1); EmitVertex();
  position = gl_Position = projection * vec4(A.xy, -A.z, 1); EmitVertex();
  position = gl_Position = projection * vec4(D.xy, -D.z, 1); EmitVertex();

	EndPrimitive();
}
)zzz",

// must use every input from geometry shader
  .fragment = R"zzz(#version 460 core
out vec4 fragment_color;
in vec4 position;
in vec4 frag_color;

void main()
{
  fragment_color = frag_color;
}
)zzz",
};

} rect_program;
