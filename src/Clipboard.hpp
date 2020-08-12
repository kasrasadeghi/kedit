#pragma once

#include "Rope.hpp"
#include "Cursor.hpp"

struct Clipboard {
  std::vector<Rope> kill_ring;
  Cursor shadow_cursor;
};
