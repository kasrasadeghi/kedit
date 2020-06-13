#pragma once

#include "Buffer.hpp"

#include <backbone-core-cpp/File.hpp>
#include <kgfx/RenderWindow.hpp>
#include <kgfx/TextRenderer.hpp>

#include <string>

struct FileBuffer {
  Buffer* buffer;

  File file;
  StringView file_contents = "";

  inline bool invariant()
    { return file_contents._length > 0 && file_contents._length > buffer->contents.length(); }
};
