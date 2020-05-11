#pragma once

#include <glad/glad.h>
#include <GLFW/glfw3.h>

struct ShaderSource {
	const char* vertex = nullptr;
	const char* fragment = nullptr;
	const char* geometry = nullptr;
};

GLuint
CreateProgram(ShaderSource& shader, std::initializer_list<const char*> vertex_attributes) {

	auto createShader = [](const char* source, GLenum shaderType, std::string name = "") -> GLuint {
		GLuint shader_id = 0;
		const char* source_ptr = source;
		shader_id = glCreateShader(shaderType);
		glShaderSource(shader_id, 1, &source_ptr, nullptr);
		glCompileShader(shader_id);
		int status = 0;
    glGetShaderiv(shader_id, GL_COMPILE_STATUS, &status);
		if (not status) {
			std::cout << "problem compiling shader: " << name << std::endl;
      GLint success;
      GLchar infoLog[1024];
      glGetShaderInfoLog(shader_id, 1024, NULL, infoLog);
      std::cout << infoLog << std::endl;
		}

		return shader_id;
	};

	GLuint vertex_shader_id         = createShader(shader.vertex, GL_VERTEX_SHADER, "vertex");
	GLuint geometry_shader_id       = createShader(shader.geometry, GL_GEOMETRY_SHADER, "geometry");
	GLuint fragment_shader_id       = createShader(shader.fragment, GL_FRAGMENT_SHADER, "fragment");

	// @output program_id
	GLuint program_id = glCreateProgram();
	glAttachShader(program_id, vertex_shader_id);
	glAttachShader(program_id, fragment_shader_id);
	glAttachShader(program_id, geometry_shader_id);

	// Bind attributes.
	int count = 0;
	for (const char* vertex_attribute : vertex_attributes) {
		glBindAttribLocation(program_id, count++, vertex_attribute);
	}
	glBindFragDataLocation(program_id, 0, "fragment_color");
	glLinkProgram(program_id);

  GLint success;
  glGetProgramiv(program_id, GL_LINK_STATUS, &success);
  if (not success) {
    GLchar infoLog[1024];
    glGetShaderInfoLog(program_id, 1024, NULL, infoLog);
    std::cout << infoLog << std::endl;
  }

	return program_id;
}