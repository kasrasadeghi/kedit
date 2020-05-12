#pragma once

#include <backbone-core-cpp/File.hpp>

#include <string>

struct Buffer {
  File file;
  StringView file_contents = "";
  Rope contents;
};
