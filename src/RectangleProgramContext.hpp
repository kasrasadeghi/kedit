#pragma once

#include "Shaders.hpp"

#include <glm/gtc/matrix_transform.hpp>

struct RectProgramContext {
  std::vector<glm::vec2> corner_vertices;
  std::vector<glm::uvec3> corner_indices;
  
  struct Instance {
    Instance(glm::vec2 p, glm::vec2 dim):
      tlx(p.x), tly(p.y), dx(dim.x), dy(dim.y) {}
    float tlx;
    float tly;

    float dx;
    float dy;

    friend std::ostream& operator<< (std::ostream& o, const Instance& rect)
      { return o << rect.tlx << ", " << rect.tly << ", " <<  rect.dx << ", " << rect.dy; }
  } __attribute__((packed));
  
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
  inline void init() {
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

    instances.emplace_back(glm::vec2{0, 0}, glm::vec2{50, 50});
    instances.emplace_back(glm::vec2{500, 500}, glm::vec2{100, 100});

    // set up VAO, VBO, and uniforms
    glGenVertexArrays(1, &rect_program.VAO);
    glBindVertexArray(rect_program.VAO);
    glGenBuffers(3, (GLuint*)(&rect_program.buffer));

    const auto VAO = rect_program.VAO;
    const auto VBO = rect_program.buffer.vertex;
    const auto EBO = rect_program.buffer.elements;
    const auto IBO = rect_program.buffer.instance;

    constexpr auto vertex_position = rect_program.attrib.vertex_position;
    constexpr auto instance_rect = rect_program.attrib.instance_offset;

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
      glVertexAttribPointer(    instance_rect, 4, GL_FLOAT, GL_FALSE, sizeof(Instance), (void*)(0));
      glVertexAttribDivisor(    instance_rect, 1);  // sets this attribute to be instanced

    // compile shader program
    rect_program_id = CreateProgram(rect_program.sources, {"vertex_position", "instance_rect"});
    glUseProgram(rect_program_id);

    // uniform.view      = glGetUniformLocation(rect_program_id, "view");
    uniform.projection = glGetUniformLocation(rect_program_id, "projection");
  }
};
