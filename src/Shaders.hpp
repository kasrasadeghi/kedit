#pragma once

#include <kgfx/ShaderUtil.hpp>

#include <glad/glad.h>
#include <GLFW/glfw3.h>

inline struct rect_program_ {

struct attrib_ {
  constexpr static GLuint vertex_position = 0;
  constexpr static GLuint instance_offset = 1;
} attrib;

GLuint VAO; // array object

struct buffer_ {
  GLuint vertex; // VBO vertex buffer object
  GLuint elements; // EBO vertex elements object
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

// output to geometry shader
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
  gl_Position = vec4(pos + top_left, 0, 1);
}
)zzz",

  .geometry =
R"zzz(#version 460 core

// layout description between vertex and fragment shader
layout (triangles) in;
layout (triangle_strip, max_vertices = 4) out;

// input from vertex shader is only gl_in
// output to fragment shader
out vec4 position;
// out vec4 gl_Position

uniform mat4 projection;

//
//  A  D     A--D         1--3
//  |\    -> |\ |  order: |\ |  order is for triangle_strip,
//  | \      | \|         | \|  so B A C D
//  B--C     B--C         0--2
//

void main()
{

	vec3 A = gl_in[0].gl_Position.xyz;
	vec3 B = gl_in[1].gl_Position.xyz;
	vec3 C = gl_in[2].gl_Position.xyz;
  vec3 D = A + (C - B);

	// perimeter = 2*length(A - B) + 2*length(B - C);

  // TODO @ref1
  position = gl_Position = projection * vec4(B.xy, 0.5, 1); EmitVertex();
  position = gl_Position = projection * vec4(A.xy, 0.5, 1); EmitVertex();
  position = gl_Position = projection * vec4(C.xy, 0.5, 1); EmitVertex();
  position = gl_Position = projection * vec4(D.xy, 0.5, 1); EmitVertex();

	EndPrimitive();
}
)zzz",

// must use every input from geometry shader
  .fragment = R"zzz(#version 460 core
out vec4 fragment_color;
in vec4 position;

void main()
{
  fragment_color = vec4(0.1, 0.1, 0.1, 1);
}
)zzz",
};

} rect_program;
