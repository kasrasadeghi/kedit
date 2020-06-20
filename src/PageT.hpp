#pragma once

#include <ostream>

enum class Type : size_t { NoneT, FileBufferT, MenuT };

inline std::ostream& operator<<(std::ostream& o, Type t)
  {
    if (Type::NoneT == t)       return o << "NoneT";
    if (Type::FileBufferT == t) return o << "FileBufferT";
    if (Type::MenuT == t)       return o << "MenuT";
    return o << (size_t)t;
  }
