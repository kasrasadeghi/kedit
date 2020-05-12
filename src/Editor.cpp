#include "Editor.hpp"

void Editor::loadFile(StringView file_path)
  {
    _buffers.push_back({});
    Buffer& curr = _buffers.back();

    // TODO make sure buffer unreads and closes file
    curr.file = File::open(file_path);
    curr.file_contents = curr.file.read();
    curr.contents.make(curr.file_contents);
  }

void Editor::verticalScroll(double scroll_y)
  {
    Buffer& curr = _buffers.back();
    curr.scroll_offset += scroll_y;
  }
