#pragma once

#include <iostream>
#include <sstream>
#include <glm/gtx/string_cast.hpp>
#include <experimental/type_traits>

// TODO: use concepts in C++20
// thanks to https://github.com/pycpp/sfinae
// thanks to @dot in (discord channel (c++ in #cpp)) on the (#include server)


template <typename T>
concept HasLeftShift = requires(T t)
  {
    { std::cout << t } -> std::same_as<std::ostream&>;
  };

template <typename T>
concept HasGlmToString = requires(T t)
  {
    { glm::to_string(t) } -> std::same_as<std::string>;
  };

template <typename T>
concept HasStdToString = requires(T t)
  {
    { std::to_string(t) } -> std::same_as<std::string>;
  };


// TODO: make a str() that takes in multiple arguments

template <typename T>
inline std::string str(T o) {
  if constexpr(HasStdToString<T>) {
    return std::to_string(o);
  }
  // else if constexpr(HasGlmToString<T>) {
  //   return glm::to_string(o);
  // }
  else if constexpr(HasLeftShift<T>) {
    std::stringstream i;
    i << o;
    return i.str();
  }
  else {
    // static_assert(false) doesn't compile??
    std::cout << "OH NO GOD PLEASE HELP" << std::endl;
    exit(1);
  }
}

template <>
inline std::string str<const char*>(const char* o) {
  return std::string(o);
}

template <>
inline std::string str<char>(char c) {
  return std::string() + c;
}
