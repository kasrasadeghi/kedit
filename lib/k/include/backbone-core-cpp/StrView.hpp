#pragma once

#include <string>
#include <ostream>

struct StringView {
  char* _data = nullptr;
  uint64_t _length = 0;

  StringView(std::string& s) : _data(const_cast<char*>(s.c_str())), _length(s.length()) {}

  StringView(char* cstr, uint64_t len) : _data(cstr), _length(len) {}

  // Note: length = N - 1 to ignore the null terminator
  template <int N>
  StringView(const char (&cstring)[N]) : _data((char*)(cstring)), _length(N - 1) {}

  std::string stringCopy()
    { return std::string(_data, _length); }

  const char* data()
    { return _data; }

  const char* end() const
    { return _data + _length; }
};


inline std::ostream& operator<< (std::ostream& os, const StringView str)
  {
    os.write(str._data, str._length);
    return os;
  }
