#pragma once

#include <iostream>
#include <sstream>
#include <glm/gtx/string_cast.hpp>
#include <experimental/type_traits>

// TODO: use concepts in C++20
// thanks to https://github.com/pycpp/sfinae
// thanks to @dot in (discord channel (c++ in #cpp)) on the (#include server)

// decltype(decl_lvalue<T>) gives an l-value version of T
// operators need an l-value on the left side
template <typename T>
std::add_lvalue_reference_t<T> decl_lvalue() noexcept;


template <typename T, typename U>
using has_left_shift_test = decltype(decl_lvalue<T>() << std::declval<U>());

template<typename T, typename U>
constexpr bool has_left_shift_v = std::experimental::is_detected_v<has_left_shift_test, T, U>;


template <typename T>
using has_glm_to_string_test = decltype(glm::to_string(std::declval<T>()));

template<typename T>
constexpr bool has_glm_to_string_v = std::experimental::is_detected_v<has_glm_to_string_test, T>;


template <typename T>
using has_std_to_string_test = decltype(std::to_string(std::declval<T>()));

template<typename T>
constexpr bool has_std_to_string_v = std::experimental::is_detected_v<has_std_to_string_test, T>;


template <typename T>
std::string str(T o) {
  if constexpr(has_std_to_string_v<T>) {
    return std::to_string(o);
  } else 
  if constexpr(has_glm_to_string_v<T>) {
    return glm::to_string(o);
  } else 
  if constexpr(has_left_shift_v<std::ostream, T>) {
    std::stringstream i;
    i << o; 
    return i.str();
  } else 
  {
    // static_assert(false) doesn't compile??
    std::cout << "OH NO GOD PLEASE HELP" << std::endl;
    exit(1);
  }
}

template <>
std::string str<const char*>(const char* o) {
  return std::string(o);
}