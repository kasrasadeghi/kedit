#pragma once

#include "Shaders.hpp"

#include <backbone-core-cpp/Print.hpp>

#include <glm/gtc/matrix_transform.hpp>

struct RectProgramContext {
  std::vector<glm::vec2> corner_vertices;
  std::vector<glm::uvec3> corner_indices;

  struct Instance {
    inline Instance(glm::vec2 position, glm::vec2 dimension, glm::vec4 color_, float z_level):
      tlx(position.x), tly(position.y), dx(dimension.x), dy(dimension.y), color(color_), z(z_level) {}
    float tlx;
    float tly;

    float dx;
    float dy;

    glm::vec4 color;

    float z;

    friend std::ostream& operator<< (std::ostream& o, const Instance& rect)
      { return o << rect.tlx << ", " << rect.tly << ", " <<  rect.dx << ", " << rect.dy; }
  };

  std::vector<Instance> instances;

  GLuint rect_program_id;

  struct uniform_ {
    // GLint view = 0; // TODO support panning around
    GLint projection = 0;
  } uniform;

  /**
   *
   * Set up OpenGL stuff
   * - Generate base vertices and faces
   * - Set up VAO, VBO, and uniform stuff
   *
   * Rectangle Shader Setup
   * create vertices and indices
   * - indices are for elements array, lets you reuse vertices
   *
   * Vector Space Overview
   * window projection: ortho(0, width, height, 0), right-handed
   * 0, 0
   *       -, -
   *               width, height
   *
   * opengl: left-handed
   * -1   1             1,  1
   *           0,  0
   * -1, -1             1, -1
   */
  inline void init(void)
    {
      /*
       *  A  D        0
       *  |\   order: |\   so it's counter-clockwise (CCW)
       *  | \         | \
       *  C--B        2--1
       */

      corner_vertices.emplace_back(0,  0); // 0
      corner_vertices.emplace_back(1,  1); // 1
      corner_vertices.emplace_back(0,  1); // 2

      corner_indices.emplace_back(0, 1, 2); // CCW order

      // instances.emplace_back(glm::vec2{0, 0}, glm::vec2{400, 400});
      // instances.emplace_back(glm::vec2{500, 500}, glm::vec2{100, 100});

      // set up VAO, VBO, and uniforms
      glGenVertexArrays(1, &rect_program.VAO);
      glBindVertexArray(rect_program.VAO);
      glGenBuffers(3, (GLuint*)(&rect_program.buffer));

      const auto VAO = rect_program.VAO;
      const auto VBO = rect_program.buffer.vertex;
      const auto EBO = rect_program.buffer.element;
      const auto IBO = rect_program.buffer.instance;

      constexpr auto vertex_position = rect_program.attrib.vertex_position;
      constexpr auto instance_rect   = rect_program.attrib.instance_offset;
      constexpr auto instance_color  = rect_program.attrib.instance_color;
      constexpr auto instance_z      = rect_program.attrib.instance_z;

      // Setup element array buffer.
      glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, EBO);
        glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(glm::uvec3) * corner_indices.size(), corner_indices.data(), GL_STATIC_DRAW);

      // Bind vertex attributes: first per-vertex, then per-instance.
      glBindBuffer(GL_ARRAY_BUFFER, VBO);
        glBufferData(GL_ARRAY_BUFFER, sizeof(glm::vec2) * corner_vertices.size(), corner_vertices.data(), GL_STATIC_DRAW);
        glEnableVertexAttribArray(vertex_position);
        glVertexAttribPointer(    vertex_position, 2, GL_FLOAT, GL_FALSE, 0, 0);

      glBindBuffer(GL_ARRAY_BUFFER, IBO);
        glBufferData(GL_ARRAY_BUFFER, sizeof(Instance) * instances.size(), instances.data(), GL_STATIC_DRAW);
        glEnableVertexAttribArray(instance_rect);
        glVertexAttribPointer(    instance_rect, 4, GL_FLOAT, GL_FALSE, sizeof(Instance), (void*)(offsetof(Instance, tlx)));
        glVertexAttribDivisor(    instance_rect, 1);  // sets this attribute to be instanced

        glEnableVertexAttribArray(instance_color);
        glVertexAttribPointer(    instance_color, 4, GL_FLOAT, GL_FALSE, sizeof(Instance), (void*)(offsetof(Instance, color)));
        glVertexAttribDivisor(    instance_color, 1);  // sets this attribute to be instanced

        glEnableVertexAttribArray(instance_z);
        glVertexAttribPointer(    instance_z, 1, GL_FLOAT, GL_FALSE, sizeof(Instance), (void*)(offsetof(Instance, z)));
        glVertexAttribDivisor(    instance_z, 1);  // sets this attribute to be instanced


      // compile shader program
      rect_program_id = CreateProgram(rect_program.sources, {"vertex_position", "instance_rect", "instance_color"});
      glUseProgram(rect_program_id);

      // uniform.view      = glGetUniformLocation(rect_program_id, "view");
      uniform.projection = glGetUniformLocation(rect_program_id, "projection");
    }

  inline void render(int window_width, int window_height)
    {
      glm::mat4 projection_matrix = glm::ortho(0.f, (float)(window_width), (float)(window_height), 0.f);
      glm::mat4 view_matrix(1);

      glUseProgram(rect_program_id);

      // Pass in Uniform
      glUniformMatrix4fv(uniform.projection, 1, GL_FALSE, &projection_matrix[0][0]); // TODO @ref1
      // glUniformMatrix4fv(uniform.view,       1, GL_FALSE, &view[0][0]);
      // glUniform1i(       uniform.wireframe, wireframe_mode);

      glBindVertexArray(rect_program.VAO);

      glBindBuffer(GL_ARRAY_BUFFER, rect_program.buffer.instance);
      glBufferData(GL_ARRAY_BUFFER, sizeof(Instance) * instances.size(), instances.data(), GL_STATIC_DRAW);

      glDrawElementsInstanced(GL_TRIANGLES, corner_indices.size() * 3, GL_UNSIGNED_INT, NULL, instances.size());
    }
};
