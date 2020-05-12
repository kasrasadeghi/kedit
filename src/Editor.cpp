#include "Editor.hpp"

void Editor::loadFile(StringView file_path)
  {
    _buffers.push_back({});
    Buffer& curr = _buffers.back();

    curr.file = File::open(file_path);
    curr.file_contents = curr.file.read();
    curr.contents = curr.file_contents.stringCopy();
  }
