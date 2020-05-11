// From https://learnopengl.com/In-Practice/Text-Rendering

// GL includes
// #include <GL/glew.h>
#include <glad/glad.h>

// Std. Includes
#include <iostream>
#include <map>
#include <stdio.h>
#include <string>
// GLFW
#include <GLFW/glfw3.h>
// GLM
#include <glm/glm.hpp>
#include <glm/gtc/matrix_transform.hpp>
#include <glm/gtc/type_ptr.hpp>
// FreeType
#include <ft2build.h>
#include FT_FREETYPE_H

/// Holds all state information relevant to a character as loaded using FreeType
struct Character {
  GLuint TextureID;   // ID handle of the glyph texture
  glm::ivec2 Size;    // Size of glyph
  glm::ivec2 Bearing; // Offset from baseline to left/top of glyph
  GLuint Advance;     // Horizontal offset to advance to next glyph
};

void checkShaderCompileErrors(GLuint shader, std::string type) {
  GLint success;
  GLchar infoLog[1024];
  if (type != "PROGRAM") {
    glGetShaderiv(shader, GL_COMPILE_STATUS, &success);
    if (!success) {
      glGetShaderInfoLog(shader, 1024, NULL, infoLog);
      std::cout << "ERROR: Shader Compilation: " << type << "\n"
                << infoLog << "\n -- --------------------------------------------------- -- "
                << std::endl;
    }
  } else {
    glGetProgramiv(shader, GL_LINK_STATUS, &success);
    if (!success) {
      glGetProgramInfoLog(shader, 1024, NULL, infoLog);
      std::cout << "ERROR: Program Linking: " << type << "\n"
                << infoLog << "\n -- --------------------------------------------------- -- "
                << std::endl;
    }
  }
}

inline const char* text_fragment_shader = R"zzz(
#version 330 core
in vec2 TexCoords;
out vec4 color;

uniform sampler2D text;
uniform vec4 textColor;

void main()
{    
  vec4 sampled = vec4(1.0, 1.0, 1.0, texture(text, TexCoords).r);
  color = textColor * sampled;
}  
)zzz";

inline const char* text_vertex_shader = R"zzz(
#version 330 core
layout (location = 0) in vec4 vertex; // <vec2 pos, vec2 tex>
out vec2 TexCoords;

uniform mat4 projection;

void main()
{
  gl_Position = projection * vec4(vertex.xy, 0.0, 1.0);
  TexCoords = vertex.zw;
}
)zzz";

class TextRenderer {
  std::map<GLchar, Character> _characters;
  GLuint _VAO;
  GLuint _VBO;
  GLuint _shaderID = 0;
  GLuint _shader_proj_loc = 0;
  GLuint _shader_color_loc = 0;
  
public:
  TextRenderer(float window_width, float window_height) {
    if (_shaderID == 0) {
      _shaderID = makeShader();
    }

    // Set OpenGL options
    glEnable(GL_CULL_FACE);
    glEnable(GL_BLEND);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

    // Set up the shader
    glUseProgram(_shaderID);
    _shader_proj_loc = glGetUniformLocation(_shaderID, "projection");
    _shader_color_loc = glGetUniformLocation(_shaderID, "textColor");
    glm::mat4 proj = glm::ortho(0.f, window_width, window_height, 0.f);
    glUniformMatrix4fv(_shader_proj_loc, 1, GL_FALSE, &proj[0][0]);

    // FreeType
    FT_Library ft;
    // All functions return a value different than 0 whenever an error occurred
    if (FT_Init_FreeType(&ft))
      std::cout << "ERROR::FREETYPE: Could not init FreeType Library" << std::endl;

    // Load font as face
    FT_Face face;
    if (FT_New_Face(ft, "fonts/arial.ttf", 0, &face))
      std::cout << "ERROR::FREETYPE: Failed to load font" << std::endl;

    // Set size to load glyphs as
    FT_Set_Pixel_Sizes(face, 0, 28);

    // Disable byte-alignment restriction
    glPixelStorei(GL_UNPACK_ALIGNMENT, 1);

    // Load first 128 characters of ASCII set
    for (GLubyte c = 0; c < 128; c++) {
      // Load character glyph
      if (FT_Load_Char(face, c, FT_LOAD_RENDER)) {
        std::cout << "ERROR::FREETYTPE: Failed to load Glyph" << std::endl;
        continue;
      }
      // Generate texture
      GLuint texture;
      glGenTextures(1, &texture);
      glBindTexture(GL_TEXTURE_2D, texture);
      glTexImage2D(GL_TEXTURE_2D, 0, GL_RED, face->glyph->bitmap.width, face->glyph->bitmap.rows, 0,
                   GL_RED, GL_UNSIGNED_BYTE, face->glyph->bitmap.buffer);
      // Set texture options
      glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
      glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
      glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
      glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
      // Now store character for later use
      Character character = {texture,
                             glm::ivec2(face->glyph->bitmap.width, face->glyph->bitmap.rows),
                             glm::ivec2(face->glyph->bitmap_left, face->glyph->bitmap_top),
                             static_cast<GLuint>(face->glyph->advance.x)};
      _characters[c] = character;
    }
    glBindTexture(GL_TEXTURE_2D, 0);
    // Destroy FreeType once we're finished
    FT_Done_Face(face);
    FT_Done_FreeType(ft);

    // Configure VAO/VBO for texture quads
    glGenVertexArrays(1, &_VAO);
    glGenBuffers(1, &_VBO);
    glBindVertexArray(_VAO);
    glBindBuffer(GL_ARRAY_BUFFER, _VBO);
    glBufferData(GL_ARRAY_BUFFER, sizeof(GLfloat) * 6 * 4, NULL, GL_DYNAMIC_DRAW);
    glEnableVertexAttribArray(0);
    glVertexAttribPointer(0, 4, GL_FLOAT, GL_FALSE, 4 * sizeof(GLfloat), 0);
    glBindBuffer(GL_ARRAY_BUFFER, 0);
    glBindVertexArray(0);
  }

  GLuint makeShader() {
    // vertex shader
    GLuint vertex = glCreateShader(GL_VERTEX_SHADER);
    glShaderSource(vertex, 1, &text_vertex_shader, NULL);
    glCompileShader(vertex);
    checkShaderCompileErrors(vertex, "VERTEX");
    // fragment Shader
    GLuint fragment = glCreateShader(GL_FRAGMENT_SHADER);
    glShaderSource(fragment, 1, &text_fragment_shader, NULL);
    glCompileShader(fragment);
    checkShaderCompileErrors(fragment, "FRAGMENT");
    // shader Program
    GLuint ID = glCreateProgram();
    glAttachShader(ID, vertex);
    glAttachShader(ID, fragment);
    glLinkProgram(ID);
    checkShaderCompileErrors(ID, "PROGRAM");
    // delete the shaders as they're linked into our program now and no longer necessery
    glDeleteShader(vertex);
    glDeleteShader(fragment);
    return ID;
  }

  GLfloat renderText(std::string text, GLfloat x, GLfloat y, GLfloat scale, glm::vec4 color = glm::vec4(1)) {
    // Activate corresponding render state
    glEnable(GL_BLEND);
    glUseProgram(_shaderID);
    glUniform4f(_shader_color_loc, color.x, color.y, color.z, color.w);
    glActiveTexture(GL_TEXTURE0);
    glBindVertexArray(_VAO);

    // Iterate through all characters
    std::string::const_iterator c;
    for (c = text.begin(); c != text.end(); c++) {
      Character ch = _characters[*c];

      GLfloat xpos = x + ch.Bearing.x * scale;
      GLfloat ypos = y + (ch.Size.y - ch.Bearing.y) * scale;

      GLfloat w = ch.Size.x * scale;
      GLfloat h = ch.Size.y * scale;

      // clang-format off
      // Update VBO for each character
      GLfloat vertices[6][4] = {
        {xpos,     ypos - h, 0, 0},   
        {xpos,     ypos,     0, 1},
        {xpos + w, ypos - h, 1, 0},

        {xpos + w, ypos - h, 1, 0},
        {xpos,     ypos,     0, 1},
        {xpos + w, ypos,     1, 1},
      };
      // clang-format on

      // Render glyph texture over quad
      glBindTexture(GL_TEXTURE_2D, ch.TextureID);
      // Update content of VBO memory
      glBindBuffer(GL_ARRAY_BUFFER, _VBO);
      glBufferSubData(GL_ARRAY_BUFFER, 0, sizeof(vertices), vertices);
      // Be sure to use glBufferSubData and not glBufferData

      glBindBuffer(GL_ARRAY_BUFFER, 0);
      // Render quad
      glDrawArrays(GL_TRIANGLES, 0, 6);
      // Now advance cursors for next glyph (note that advance is number of 1/64 pixels)
      x += (ch.Advance >> 6) * scale; // Bitshift by 6 to get value in pixels (2^6 = 64 (divide
                                      // amount of 1/64th pixels by 64 to get amount of pixels))
    }
    glBindTexture(GL_TEXTURE_2D, 0);
    glBindVertexArray(0);
    return x;
  }

  GLfloat textWidth(std::string text, GLfloat scale = 1) {
    // Iterate through all characters
    std::string::const_iterator c;
    GLfloat width = 0;

    for (c = text.begin(); c != text.end(); c++) {
      Character ch = _characters[*c];

      width += (ch.Advance >> 6) * scale; // Bitshift by 6 to get value in pixels (2^6 = 64 (divide
                                          // amount of 1/64th pixels by 64 to get amount of pixels))
    }

    return width;
  }
};
