#pragma once

#include "Buffer.hpp"

#include <backbone-core-cpp/File.hpp>
#include <kgfx/RenderWindow.hpp>
#include <kgfx/TextRenderer.hpp>

#include <string>

struct FileBuffer {
  Buffer buffer;

  File file;
  StringView file_contents = "";
};
